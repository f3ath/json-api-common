import 'package:json_api_common/routing.dart';
import 'package:maybe_just_nothing/maybe_just_nothing.dart';

class TargetMatcher {
  const TargetMatcher();

  Maybe<CollectionTarget> collection(Uri uri) => Just(uri.pathSegments)
      .where((_) => _.length == 1)
      .map((_) => CollectionTarget(_[0]));

  Maybe<ResourceTarget> resource(Uri uri) => Just(uri.pathSegments)
      .where((_) => _.length == 2)
      .map((_) => ResourceTarget(_[0], _[1]));

  Maybe<RelatedTarget> related(Uri uri) => Just(uri.pathSegments)
      .where((_) => _.length == 3)
      .map((_) => RelatedTarget(_[0], _[1], _[2]));

  Maybe<RelationshipTarget> relationship(Uri uri) => Just(uri.pathSegments)
      .where((_) => _.length == 4 && _[2] == 'relationships')
      .map((_) => RelationshipTarget(_[0], _[1], _[4]));

  Maybe<Target> match(Uri uri) => const Nothing<Target>()
      .chain(() => collection(uri))
      .chain(() => resource(uri))
      .chain(() => related(uri))
      .chain(() => relationship(uri));
}
