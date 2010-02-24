From: akpm@linux-foundation.org
Subject: + mqueue-fix-typo-failues-failures.patch added to -mm tree
Date: Wed, 24 Feb 2010 14:02:45 -0800
Message-ID: <201002242202.o1OM2jMZ023011@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34704 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758386Ab0BXWLq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Feb 2010 17:11:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: andre.goddard@gmail.com, adobriyan@gmail.com, clg@fr.ibm.com, serue@us.ibm.com, viro@zeniv.linux.org.uk


The patch titled
     mqueue: fix typo "failues" -> "failures"
has been added to the -mm tree.  Its filename is
     mqueue-fix-typo-failues-failures.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: mqueue: fix typo "failues" -> "failures"
=46rom: Andr=E9 Goddard Rosa <andre.goddard@gmail.com>

Signed-off-by: Andr=E9 Goddard Rosa <andre.goddard@gmail.com>
Cc: Serge E. Hallyn <serue@us.ibm.com>
Cc: Cedric Le Goater <clg@fr.ibm.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/mqueue.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN ipc/mqueue.c~mqueue-fix-typo-failues-failures ipc/mqueue.c
--- a/ipc/mqueue.c~mqueue-fix-typo-failues-failures
+++ a/ipc/mqueue.c
@@ -1296,7 +1296,7 @@ static int __init init_mqueue_fs(void)
 	if (mqueue_inode_cachep =3D=3D NULL)
 		return -ENOMEM;
=20
-	/* ignore failues - they are not fatal */
+	/* ignore failures - they are not fatal */
 	mq_sysctl_table =3D mq_register_sysctl_table();
=20
 	error =3D register_filesystem(&mqueue_fs_type);
_

Patches currently in -mm which might be from andre.goddard@gmail.com ar=
e

linux-next.patch
mqueue-fix-mq_open-file-descriptor-leak-on-user-space-processes.patch
mqueue-remove-unneeded-info-messages-initialization.patch
mqueue-apply-mathematics-distributivity-on-mq_bytes-calculation.patch
mqueue-simplify-do_open-error-handling.patch
mqueue-only-set-error-codes-if-they-are-really-necessary.patch
mqueue-fix-typo-failues-failures.patch
lib-stringc-simplify-stricmp.patch
lib-stringc-simplify-strnstr.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
