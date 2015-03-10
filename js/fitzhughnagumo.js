      // Initialise board
      board = JXG.JSXGraph.initBoard('fitzbox', {boundingbox: [-1.0, 3.0, 250.0, -3.0], axis: true, grid: false});
   
      // Define sliders to dynamically change parameters of the equations and create text elements to describe them
      intensite = board.createElement('slider', [[180.0,2.6],[230.0,2.6],[0.0,0.4,1.0]],{name:'I',strokeColor:'black',fillColor:'black'});
      intensitet = board.createElement('text', [180,2.45, "Intensité du courant"], {fixed:true});
      epsilon = board.createElement('slider', [[180.0,2.3],[230.0,2.3],[0.0,0.08,0.2]],{name:'&epsilon;',strokeColor:'black',fillColor:'black'});
      epsilont = board.createElement('text', [180,2.15, "échelle de temps"], {fixed:true});
      c = board.createElement('slider', [[100.0,2.6],[150.0,2.6],[0.0,0.8,1.0]],{name:'c',strokeColor:'black',fillColor:'black'});
      ct = board.createElement('text', [100,2.45, "constante c"], {fixed:true});
      b = board.createElement('slider', [[100.0,2.3],[150.0,2.3],[0.0,0.7,1.0]],{name:'b',strokeColor:'black',fillColor:'black'});
      bt = board.createElement('text', [100,2.15, "constante b"], {fixed:true});
      
      // Dynamic initial value as gliders on the y-axis
      startv = board.createElement('glider', [0, -1.1993, board.defaultAxes.y], {name:'u',strokeColor:'red',fillColor:'red'});
      startw = board.createElement('glider', [0, -0.6243, board.defaultAxes.y], {name:'w',strokeColor:'blue',fillColor:'blue'});
   
   
      // Variables for the JXG.Curves
      var g3 = null;
      var g4 = null;
   
      // Initialise ODE and solve it with JXG.Math.Numerics.rungeKutta()
      function ode() {
          // evaluation interval
          var tspan = [0, 250];
          // Number of steps. 1000 should be enough
          var N = 1000;
   
          // Right hand side of the ODE dx/dt = f(t, x)
          var f = function(t, x) {
              var u_intensite = intensite.Value();//0.1;
              var w_epsilon = epsilon.Value();//0.08;
              var w_c = c.Value();//0.8;
              var w_b = b.Value();//0.7;
   
              var y = [];
              y[0] = x[0] - x[0]*x[0]*x[0]/3 - x[1] + u_intensite;
              y[1] = w_epsilon*( x[0] + w_b - w_c*x[1] );
   
              return y;
          }
   
          // Initial value
          var x0 = [startv.Y(), startw.Y()];
   
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
      var datav = [];
      var dataw = [];
      for(var i=0; i<data.length; i++) {
          t[i] = data[i][2];
          datav[i] = data[i][0];
          dataw[i] = data[i][1];
      }
   
      // Plot Predator
      g3 = board.createElement('curve', [t, datav], {strokeColor:'red', strokeWidth:'2px'});
      g3.updateDataArray = function() {
          var data = ode();
          this.dataX = [];
          this.dataY = [];
          for(var i=0; i<data.length; i++) {
              this.dataX[i] = t[i];
              this.dataY[i] = data[i][0];
          }
      }
   
      // Plot Prey
      g4 = board.createElement('curve', [t, dataw], {strokeColor:'blue', strokeWidth:'2px'});
      g4.updateDataArray = function() {
          var data = ode();
          this.dataX = [];
          this.dataY = [];
          for(var i=0; i<data.length; i++) {
              this.dataX[i] = t[i];
              this.dataY[i] = data[i][1];
          }
      }