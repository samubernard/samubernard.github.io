      var a = [-1.0, 1.5, 250, -1.5]; // xlo yhi xhi ylo
      // Initialise board
      board = JXG.JSXGraph.initBoard('fitzbox', {boundingbox: a, axis: true, grid: false});
   
      // Define sliders to dynamically change parameters of the equations and create text elements to describe them
      couplage = board.createElement('slider',[[0.65*a[2],0.9*a[1]],[0.9*a[2],0.9*a[1]],[0.0,0.1,.6]],{name:'K',strokeColor:'black',fillColor:'black'});
      couplaget = board.createElement('text', [0.7*a[2],0.85*a[1], "Force de couplage"], {fixed:true});
      om1 = board.createElement('slider', [[0.3*a[2],0.9*a[1]],[0.5*a[2],0.9*a[1]],[-1,0.2,1.0]],{name:'&omega;1',strokeColor:'black',fillColor:'black'});
      om1t = board.createElement('text', [0.3*a[2],0.85*a[1], "fréquence 1"], {fixed:true});
      om2 = board.createElement('slider', [[0.3*a[2],0.75*a[1]],[0.5*a[2],0.75*a[1]],[-1,-0.1,1.0]],{name:'&omega;2',strokeColor:'black',fillColor:'black'});
      om2t = board.createElement('text', [0.3*a[2],0.70*a[1], "fréquence 2"], {fixed:true});
      
      // Dynamic initial value as gliders on the y-axis
      start1 = board.createElement('glider', [0, 0.2, board.defaultAxes.y], {name:'&phi;1',strokeColor:'red',fillColor:'red'});
      start2 = board.createElement('glider', [0, 0.5, board.defaultAxes.y], {name:'&phi;2',strokeColor:'blue',fillColor:'blue'});
   
   
      // Variables for the JXG.Curves
      var g3 = null;
      var g4 = null;
      var g5 = null;
   
      // Initialise ODE and solve it with JXG.Math.Numerics.rungeKutta()
      function ode() {
          // evaluation interval
          var tspan = [0, 250];
          // Number of steps. 1000 should be enough
          var N = 1001;
   
          // Right hand side of the ODE dx/dt = f(t, x)
          var f = function(t, x) {
              var K = couplage.Value();
              var omega1 = om1.Value();
              var omega2 = om2.Value();
   
              var y = [];
              y[0] = omega1 + 0.5*K*Math.sin(x[1]-x[0]);
              y[1] = omega2 + 0.5*K*Math.sin(x[0]-x[1]);
   
              return y;
          }
   
          // Initial value
          var x0 = [start1.Y(), start2.Y()];
   
          // Solve ode
          var data = JXG.Math.Numerics.rungeKutta('rk4', x0, tspan, N, f);
   
          // to plot the data against time we need the times where the equations were solved
          var t = [];
          var q = tspan[0];
          var h = (tspan[1]-tspan[0])/N;
          for(var i=0; i<data.length; i++) {
              data[i].push(q);
              q += h;
          }
   
          return data;
      }
   
      // get data points
      var data = ode();
   
      // copy data to arrays so we can plot it using JXG.Curve
      var t = [];
      var data1 = [];
      var data2 = [];
      var dataDiff = [];
      for(var i=0; i<data.length; i++) {
          t[i] = data[i][2];
          data1[i] = Math.sin(data[i][0]);
          data2[i] = Math.sin(data[i][1]);
          dataDiff[i] = data1[i]-data2[i];
      }
   
      // Plot phi1
      g3 = board.createElement('curve', [t, data1], {strokeColor:'red', strokeWidth:'4px'});
      g3.updateDataArray = function() {
          var data = ode();
          this.dataX = [];
          this.dataY = [];
          for(var i=0; i<data.length; i++) {
              this.dataX[i] = t[i];
              this.dataY[i] = Math.sin(data[i][0]);
          }
      }
   
      // Plot phi2
      g4 = board.createElement('curve', [t, data2], {strokeColor:'blue', strokeWidth:'4px'});
      g4.updateDataArray = function() {
          var data = ode();
          this.dataX = [];
          this.dataY = [];
          for(var i=0; i<data.length; i++) {
              this.dataX[i] = t[i];
              this.dataY[i] = Math.sin(data[i][1]);
          }
      }

      // Plot phase diff
      g5 = board.createElement('curve', [t, dataDiff], {strokeColor:'darkgreen', strokeWidth:'1px'});
      g5.updateDataArray = function() {
          var data = ode();
          this.dataX = [];
          this.dataY = [];
          for(var i=0; i<data.length; i++) {
              this.dataX[i] = t[i];
              this.dataY[i] = data[i][0] - data[i][1];
          }
      }