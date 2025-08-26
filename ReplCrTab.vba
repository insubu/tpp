{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "Run main.py",
      "type": "python",
      "request": "launch",
      "program": "${workspaceFolder}/main.py",
      "console": "integratedTerminal",
      "args": ["--ticker", "8306", "--mode", "debug"],
      "cwd": "${workspaceFolder}/scripts",
      "env": {
        "PYTHONPATH": "${workspaceFolder}/lib"
      }
    }
  ]
}
