From: akpm@linux-foundation.org
Subject: - jsm-remove-further-unneeded-crud-fix.patch removed from -mm tree
Date: Tue, 16 Oct 2007 15:10:06 -0700
Message-ID: <200710162210.l9GMA73g020212@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48978 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966012AbXJPWKm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 18:10:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: michal.k.k.piotrowski@gmail.com, alan@redhat.com, scottk@digi.com, mm-commits@vger.kernel.org


The patch titled
     drivers/serial/jsm/jsm_tty.c remove unused variable
has been removed from the -mm tree.  Its filename was
     jsm-remove-further-unneeded-crud-fix.patch

This patch was dropped because it was folded into jsm-remove-further-un=
needed-crud.patch

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
jsm-remove-further-unneeded-crud.patch
jsm-remove-further-unneeded-crud-fix.patch
revoke-special-mmap-handling-vs-fault-vs-invalidate.patch
reiser4.patch
