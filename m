From: akpm@linux-foundation.org
Subject: + jsm-remove-further-unneeded-crud-fix.patch added to -mm tree
Date: Wed, 22 Aug 2007 15:41:54 -0700
Message-ID: <200708222241.l7MMfsfI008583@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49913 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932898AbXHVWmM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 22 Aug 2007 18:42:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: michal.k.k.piotrowski@gmail.com, alan@redhat.com, scottk@digi.com


The patch titled
     drivers/serial/jsm/jsm_tty.c remove unused variable
has been added to the -mm tree.  Its filename is
     jsm-remove-further-unneeded-crud-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to =
find
out what to do about this

------------------------------------------------------
Subject: drivers/serial/jsm/jsm_tty.c remove unused variable
=46rom: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>

drivers/serial/jsm/jsm_tty.c: In function =E2=80=98jsm_input=E2=80=99:
drivers/serial/jsm/jsm_tty.c:508: warning: unused variable =E2=80=98fli=
p_len=E2=80=99

Cc: Alan Cox <alan@redhat.com>
Cc: Scott Kilau <scottk@digi.com>=20
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/jsm/jsm_tty.c |    1 -
 1 files changed, 1 deletion(-)

diff -puN drivers/serial/jsm/jsm_tty.c~jsm-remove-further-unneeded-crud=
-fix drivers/serial/jsm/jsm_tty.c
--- a/drivers/serial/jsm/jsm_tty.c~jsm-remove-further-unneeded-crud-fix
+++ a/drivers/serial/jsm/jsm_tty.c
@@ -505,7 +505,6 @@ void jsm_input(struct jsm_channel *ch)
 	u16 tail;
 	int data_len;
 	unsigned long lock_flags;
-	int flip_len =3D 0;
 	int len =3D 0;
 	int n =3D 0;
 	int s =3D 0;
_

Patches currently in -mm which might be from michal.k.k.piotrowski@gmai=
l.com are

origin.patch
git-alsa.patch
git-dvb.patch
git-kvm.patch
git-netdev-all.patch
revert-8139too-clean-up-i-o-remapping.patch
fs-xfs-xfs_bmap_btreec2312-error-b-undeclared-first.patch
fs-remove-some-aop_truncated_page.patch
jsm-remove-further-unneeded-crud-fix.patch
revoke-special-mmap-handling-vs-fault-vs-invalidate.patch
reiser4.patch
