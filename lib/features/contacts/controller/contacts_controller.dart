import 'package:flutter_contacts/contact.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:whatsapp_clone/features/contacts/repository/contacts_repository.dart';
import 'package:whatsapp_clone/router/router.dart';

final getContactsProvider = FutureProvider((ref) {
  final contactsRepository = ref.watch(contactsRepositoryProvider);
  return contactsRepository.getContacts();
});

final contactsControllerProvider = Provider((ref) {
  final selectContactRepository = ref.watch(contactsRepositoryProvider);
  return ContactsController(
    ref: ref,
    contactsRepository: selectContactRepository,
  );
});

class ContactsController {
  final ProviderRef ref;
  final ContactsRepository contactsRepository;
  ContactsController({
    required this.ref,
    required this.contactsRepository,
  });

  void selectContact(Contact selectedContact) async {
    final userData = await contactsRepository
        .selectContact(selectedContact.phones.first.normalizedNumber);
    if (userData == null) {
      Fluttertoast.showToast(
        msg: 'This number does not exist on this app.',
      );
    } else {
      AppRouter.router.replace(
        AppRoutes.chat,
        extra: {
          'name': userData.name,
          'uid': userData.uid,
        },
      );
    }
  }
}
