# Sprint β - Bench Realism Track

## E-3b: HPCG container → nightly GitHub Actions run
- [ ] Create bench-hpcg.yml workflow
- [ ] Configure MCP runner
- [ ] Set up artifact signing
- [ ] Enable nightly schedule

## E-4b: Mini-MLPerf Draft 1 wiring
- [ ] Implement toy model runner
- [ ] Capture metrics < 10 min runtime
- [ ] Integration with pipeline
- [ ] Basic validation tests

## A-4: SHA-sig util → CI publish ✅ 
- [x] Implement *.json.sig generation
- [x] Auto-detect results directory for signing
- [x] Integration with nightly workflow
- [ ] Add signature verification (E-5)
- [ ] Set up public key distribution (E-5)
- [ ] End-to-end artifact chain (E-5)

Sprint window: 10 working days
Target: Nightly runs + signed artifacts

