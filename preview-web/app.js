// AuraWall AI Interactive Simulator App
document.addEventListener('DOMContentLoaded', () => {
  // Elements
  const dropZone = document.getElementById('dropZone');
  const fileInput = document.getElementById('fileInput');
  const imagePreview = document.getElementById('imagePreview');
  const uploadPlaceholder = document.getElementById('uploadPlaceholder');
  const analysisDetails = document.getElementById('analysisDetails');
  const subjectLabel = document.getElementById('subjectLabel');
  const clockOverlapLabel = document.getElementById('clockOverlapLabel');
  const depthScoreLabel = document.getElementById('depthScoreLabel');
  
  const styleGrid = document.getElementById('styleGrid');
  const variationsRow = document.getElementById('variationsRow');
  const btnGenerate = document.getElementById('btnGenerate');
  const btnExport = document.getElementById('btnExport');
  const btnGuide = document.getElementById('btnGuide');
  const guideModal = document.getElementById('guideModal');
  const btnCloseModal = document.getElementById('btnCloseModal');
  
  const wallpaperLayer = document.getElementById('wallpaperLayer');
  const dimmingLayer = document.getElementById('dimmingLayer');
  const depthCutoutLayer = document.getElementById('depthCutoutLayer');
  const chkDepthEffect = document.getElementById('chkDepthEffect');
  const chkDimming = document.getElementById('chkDimming');
  
  const lockTime = document.getElementById('lockTime');
  const lockDate = document.getElementById('lockDate');
  const statusTime = document.getElementById('statusTime');

  let currentSourceDataUrl = null;
  let currentStyle = 'cyber-neon';
  let generatedVariations = [];
  let selectedVariationIndex = 0;

  // 1. Clock timer
  function updateTime() {
    const now = new Date();
    const hours = String(now.getHours()).padStart(2, '0');
    const minutes = String(now.getMinutes()).padStart(2, '0');
    const timeStr = `${hours}:${minutes}`;
    
    lockTime.textContent = timeStr;
    statusTime.textContent = timeStr;

    const options = { weekday: 'long', month: 'long', day: 'numeric' };
    lockDate.textContent = now.toLocaleDateString('en-US', options).toUpperCase();
  }
  updateTime();
  setInterval(updateTime, 1000);

  // 2. Style Presets Configuration
  const styleConfigs = {
    'cyber-neon': {
      gradient: 'linear-gradient(135deg, #0B0D1B 0%, #1C103A 50%, #00F5FF 100%)',
      palettes: [
        ['#0B0D1B', '#1C103A', '#00F5FF'],
        ['#050814', '#2A0845', '#FF007F'],
        ['#000000', '#0f2027', '#203a43', '#2c5364']
      ]
    },
    'minimalist-dark': {
      gradient: 'linear-gradient(180deg, #000000 0%, #111111 70%, #222222 100%)',
      palettes: [
        ['#000000', '#111111', '#282828'],
        ['#050505', '#161616', '#3b3b3b'],
        ['#0a0a0a', '#181818', '#202020']
      ]
    },
    'cinematic-golden': {
      gradient: 'linear-gradient(135deg, #1F1206 0%, #4A2508 55%, #E69C24 100%)',
      palettes: [
        ['#1F1206', '#4A2508', '#E69C24'],
        ['#1a0f08', '#54260d', '#f39c12'],
        ['#140803', '#3d1606', '#d35400']
      ]
    },
    'abstract-glass': {
      gradient: 'linear-gradient(135deg, #0A192F 0%, #1D3557 50%, #457B9D 100%)',
      palettes: [
        ['#0A192F', '#1D3557', '#457B9D'],
        ['#0f172a', '#312e81', '#6366f1'],
        ['#111827', '#1f2937', '#93c5fd']
      ]
    },
    'anime-studio': {
      gradient: 'linear-gradient(135deg, #1A102F 0%, #3B185F 50%, #A12568 100%)',
      palettes: [
        ['#1A102F', '#3B185F', '#A12568'],
        ['#120c24', '#48206d', '#ff5e7e'],
        ['#0d0826', '#251545', '#7a206b']
      ]
    },
    'noir-monochrome': {
      gradient: 'linear-gradient(180deg, #050505 0%, #1a1a1a 60%, #ffffff 100%)',
      palettes: [
        ['#050505', '#1a1a1a', '#ffffff'],
        ['#000000', '#222222', '#e0e0e0'],
        ['#0a0a0a', '#333333', '#cccccc']
      ]
    }
  };

  // 3. Photo Import / Drag & Drop
  dropZone.addEventListener('click', () => fileInput.click());

  fileInput.addEventListener('change', (e) => {
    if (e.target.files && e.target.files[0]) {
      handleFile(e.target.files[0]);
    }
  });

  dropZone.addEventListener('dragover', (e) => {
    e.preventDefault();
    dropZone.classList.add('dragover');
  });

  dropZone.addEventListener('dragleave', () => dropZone.classList.remove('dragover'));

  dropZone.addEventListener('drop', (e) => {
    e.preventDefault();
    dropZone.classList.remove('dragover');
    if (e.dataTransfer.files && e.dataTransfer.files[0]) {
      handleFile(e.dataTransfer.files[0]);
    }
  });

  function handleFile(file) {
    if (!file.type.startsWith('image/')) {
      alert('Please upload a valid image.');
      return;
    }
    const reader = new FileReader();
    reader.onload = (event) => {
      currentSourceDataUrl = event.target.result;
      imagePreview.src = currentSourceDataUrl;
      imagePreview.classList.remove('hidden');
      uploadPlaceholder.classList.add('hidden');
      runMockAnalysis();
      generateVariations();
    };
    reader.readAsDataURL(file);
  }

  function runMockAnalysis() {
    analysisDetails.classList.remove('hidden');
    subjectLabel.textContent = 'Portrait Subject';
    clockOverlapLabel.textContent = 'Clock Safe (Depth Eligible)';
    clockOverlapLabel.className = 'tag safe';
    depthScoreLabel.textContent = '95% (Flawless Layering)';
  }

  // 4. Style Grid Selection
  styleGrid.querySelectorAll('.style-pill').forEach(pill => {
    pill.addEventListener('click', () => {
      styleGrid.querySelectorAll('.style-pill').forEach(p => p.classList.remove('active'));
      pill.classList.add('active');
      currentStyle = pill.dataset.style;
      generateVariations();
    });
  });

  // 5. Generate Variations Engine
  function generateVariations() {
    const config = styleConfigs[currentStyle] || styleConfigs['cyber-neon'];
    generatedVariations = [];
    variationsRow.innerHTML = '';

    for (let i = 0; i < 3; i++) {
      const palette = config.palettes[i % config.palettes.length];
      const canvas = document.createElement('canvas');
      canvas.width = 400;
      canvas.height = 860;
      const ctx = canvas.getContext('2d');

      // Gradient background
      const grad = ctx.createLinearGradient(0, 0, 400, 860);
      grad.addColorStop(0, palette[0]);
      grad.addColorStop(0.5, palette[1]);
      grad.addColorStop(1, palette[2]);
      ctx.fillStyle = grad;
      ctx.fillRect(0, 0, 400, 860);

      // Atmospheric glow orbs
      ctx.save();
      ctx.globalCompositeOperation = 'screen';
      ctx.beginPath();
      ctx.arc(150 + i * 40, 420 + i * 30, 180, 0, Math.PI * 2);
      ctx.fillStyle = palette[2];
      ctx.globalAlpha = 0.35;
      ctx.fill();
      ctx.restore();

      // If source image exists, composite it nicely
      if (currentSourceDataUrl) {
        const img = new Image();
        img.src = currentSourceDataUrl;
        img.onload = () => {
          ctx.save();
          ctx.shadowColor = 'rgba(0,0,0,0.6)';
          ctx.shadowBlur = 30;
          ctx.drawImage(img, 50, 240, 300, 440);
          ctx.restore();
          updateThumbnail(i, canvas);
          if (i === selectedVariationIndex) applyToPhone(canvas);
        };
      }

      generatedVariations.push(canvas);

      const thumbDiv = document.createElement('div');
      thumbDiv.className = `var-thumb ${i === 0 ? 'active' : ''}`;
      thumbDiv.appendChild(canvas);
      thumbDiv.addEventListener('click', () => {
        document.querySelectorAll('.var-thumb').forEach(t => t.classList.remove('active'));
        thumbDiv.classList.add('active');
        selectedVariationIndex = i;
        applyToPhone(canvas);
      });
      variationsRow.appendChild(thumbDiv);
    }

    applyToPhone(generatedVariations[0]);
  }

  function updateThumbnail(index, canvas) {
    const thumb = variationsRow.children[index];
    if (thumb) {
      thumb.innerHTML = '';
      thumb.appendChild(canvas);
    }
  }

  function applyToPhone(canvas) {
    const dataUrl = canvas.toDataURL('image/png');
    wallpaperLayer.style.backgroundImage = `url(${dataUrl})`;
    
    // Depth cutout simulation
    if (currentSourceDataUrl && chkDepthEffect.checked) {
      depthCutoutLayer.style.backgroundImage = `url(${currentSourceDataUrl})`;
      depthCutoutLayer.style.backgroundPosition = 'center 62%';
      depthCutoutLayer.style.backgroundSize = '70%';
      depthCutoutLayer.style.backgroundRepeat = 'no-repeat';
      depthCutoutLayer.classList.remove('hidden');
    } else {
      depthCutoutLayer.classList.add('hidden');
    }
  }

  btnGenerate.addEventListener('click', () => {
    btnGenerate.innerHTML = '<span>Synthesizing 4K Layers...</span>';
    setTimeout(() => {
      generateVariations();
      btnGenerate.innerHTML = '<svg width="18" height="18" viewBox="0 0 24 24" fill="currentColor"><path d="M12 2l2.4 7.2h7.6l-6 4.8 2.4 7.2-6.4-4.8-6.4 4.8 2.4-7.2-6-4.8h7.6z"/></svg><span>Synthesize 4K Variations</span>';
    }, 450);
  });

  // Toggles
  chkDimming.addEventListener('change', () => {
    dimmingLayer.classList.toggle('active', chkDimming.checked);
  });

  chkDepthEffect.addEventListener('change', () => {
    if (generatedVariations[selectedVariationIndex]) {
      applyToPhone(generatedVariations[selectedVariationIndex]);
    }
  });

  // Export
  btnExport.addEventListener('click', () => {
    const activeCanvas = generatedVariations[selectedVariationIndex];
    if (!activeCanvas) return;
    const link = document.createElement('a');
    link.download = `AuraWall_iPhone_${Date.now()}.png`;
    link.href = activeCanvas.toDataURL('image/png');
    link.click();
  });

  // Modal Guide
  btnGuide.addEventListener('click', () => guideModal.classList.remove('hidden'));
  btnCloseModal.addEventListener('click', () => guideModal.classList.add('hidden'));
  guideModal.addEventListener('click', (e) => {
    if (e.target === guideModal) guideModal.classList.add('hidden');
  });

  // Initial load
  generateVariations();
});
