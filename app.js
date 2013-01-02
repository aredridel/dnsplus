/*jshint node:true undef:true indent:4 */
"use strict";
/**
 * Module dependencies.
 */

var express = require('express');
var routes = require('./routes');
var passport = require('passport');
var LocalStrategy = require('passport-local').Strategy;
var sqlite3 = require('sqlite3').verbose();
var SQLiteStore = require('connect-sqlite3')(express);

var app = module.exports = express.createServer();
var db = new sqlite3.Database('dns.db');

// Configuration

app.configure(function () {
    app.set('views', __dirname + '/views');
    app.set('view engine', 'jade');
    app.use(express.bodyParser());
    app.use(express.methodOverride());
    app.use(express.cookieParser());
    app.use(express.session({
        store: new SQLiteStore(),
        secret: 'your secret',
        cookie: { maxAge: 7 * 24 * 60 * 60 * 1000 } // 1 week
    }));
    app.use(passport.initialize());
    app.use(passport.session());
    app.use(app.router);
    app.use(express['static'](__dirname + '/public'));
});

passport.use(new LocalStrategy(
    function (username, password, done) {
        db.get("SELECT id, password FROM users WHERE username = $username", {$username : username}, function (err, row) {
            if (err) { return done(err); }
            if (!row) {
                return done(null, false, { message: 'Incorrect username.' });
            }
            if (row.password != password) {
                return done(null, false, { message: 'Incorrect password.' });
            }
            return done(null, row);
        });
    }
));
app.configure('development', function () {
    app.use(express.errorHandler({ dumpExceptions: true, showStack: true }));
});

app.configure('production', function () {
    app.use(express.errorHandler());
});

// Routes

app.get('/', routes.index);

app.post('/login', passport.authenticate('local', { successRedirect: '/',
                                                    failureRedirect: '/login' }));

app.get('/login', function (req, res) {
    res.render('login', {title: 'login'});
});

app.listen(3000, function () {
    console.log("Express server listening on port %d in %s mode", app.address().port, app.settings.env);
});
