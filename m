From: akpm@linux-foundation.org
Subject: [merged] mqueue-fix-typo-failues-failures.patch removed from -mm tree
Date: Thu, 04 Mar 2010 11:41:53 -0800
Message-ID: <201003041941.o24Jfru8025957@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45612 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932257Ab0CDTl7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 4 Mar 2010 14:41:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andre.goddard@gmail.com, adobriyan@gmail.com, clg@fr.ibm.com, serue@us.ibm.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     mqueue: fix typo "failues" -> "failures"
has been removed from the -mm tree.  Its filename was
     mqueue-fix-typo-failues-failures.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

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

origin.patch
linux-next.patch
includecheck-fix-for-kernel-paramsc.patch
lib-stringc-simplify-stricmp.patch
lib-stringc-simplify-strnstr.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
