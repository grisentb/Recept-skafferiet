// Copyright (c) 2021, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_router/shelf_router.dart' as shelf_router;
import 'package:shelf_static/shelf_static.dart' as shelf_static;

import 'route_handler.dart';

Future main() async {
  connectToDatabase();
  // If the "PORT" environment variable is set, listen to it. Otherwise, 8080.
  // https://cloud.google.com/run/docs/reference/container-contract#port
  final port = int.parse(Platform.environment['PORT'] ?? '8080');

  // See https://pub.dev/documentation/shelf/latest/shelf/Cascade-class.html
  final cascade = Cascade()
      // First, serve files from the 'public' directory
      .add(_staticHandler)
      // If a corresponding file is not found, send requests to a `Router`
      .add(_router);

  // See https://pub.dev/documentation/shelf/latest/shelf_io/serve.html
  final server = await shelf_io.serve(
    // See https://pub.dev/documentation/shelf/latest/shelf/logRequests.html
    logRequests()
        // See https://pub.dev/documentation/shelf/latest/shelf/MiddlewareExtensions/addHandler.html
        .addHandler(cascade.handler),
    InternetAddress.anyIPv4, // Allows external connections
    port,
  );

  print('Serving at http://${server.address.host}:${server.port}');
}

// Serve files from the file system.
final _staticHandler =
    shelf_static.createStaticHandler('public', defaultDocument: 'index.html');

// Router instance to handler requests.
final _router = shelf_router.Router()
  ..get('/validSession/<id>/<sessionToken>', validSession)
  ..get('/login/<username>/<password>', loginHandler)
  ..get('/register/<username>/<password>', registerHandler)
  ..get('/logout/<id>/<sessionToken>', logoutHandler)
  ..get('/getCategories/<id>/<sessionToken>', getCategoriesHandler)
  ..get('/newCategory/<id>/<sessionToken>/<category>', newCategoryHandler)
  ..get('/addRecipeToCategoryHandler/<id>/<sessionToken>/<category>/<recipe>',
      addRecipeToCategoryHandler)
  ..get('/getRecipesFromCategory/<id>/<sessionToken>/<category>',
      getRecipesFromCategoryHandler)
  ..get('/getRecipes/<userId>/<sessionToken>', getRecipesHandler)
  ..get('/getMyRecipes/<userId>/<sessionToken>', getMyRecipesHandler)
  ..post('/pushRecipe/<userId>/<sessionToken>', pushRecipeHandler)
  ..post('/pushRelation/<userId>/<sessionToken>', pushRelationHandler)
  ..post('/deleteRelation/<userId>/<sessionToken>', deleteRelationHandler)
  ..post('/updateRating/<userId>/<sessionToken>', updateRatingHandler)
  ..post('/updateComment/<userId>/<sessionToken>', updateCommentHandler)
  ..post('/deleteRecipe/<userId>/<sessionToken>', deleteRecipeHandler);
