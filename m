From: akpm@linux-foundation.org
Subject: + drm-change-the-type-of-unichrome-display-adapter-pci-id=11063108.patch added to -mm tree
Date: Mon, 17 Mar 2008 16:16:56 -0700
Message-ID: <200803172316.m2HNGuq1003316@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34400 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751530AbYCQXR2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 17 Mar 2008 19:17:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: nm127@freemail.hu, airlied@linux.ie, shankargiri@gmail.com


The patch titled
     drm: change the type of Unichrome display adapter (PCI ID=3D1106:3=
108)
has been added to the -mm tree.  Its filename is
     drm-change-the-type-of-unichrome-display-adapter-pci-id=3D11063108=
=2Epatch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to =
find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: drm: change the type of Unichrome display adapter (PCI ID=3D11=
06:3108)
=46rom: M=E1rton N=E9meth <nm127@freemail.hu>

Change the type of Unichrome display adapter with PCI ID=3D1106:3108 to=
 get rid
of message "irq 16: nobody cared".

See http://bugzilla.kernel.org/show_bug.cgi?id=3D8641 for details.

Signed-off-by: Shankar Giri V <shankargiri@gmail.com>
Signed-off-by: M=E1rton N=E9meth <nm127@freemail.hu>
Cc: Dave Airlie <airlied@linux.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/drm/drm_pciids.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/char/drm/drm_pciids.h~drm-change-the-type-of-unichrom=
e-display-adapter-pci-id=3D11063108 drivers/char/drm/drm_pciids.h
--- a/drivers/char/drm/drm_pciids.h~drm-change-the-type-of-unichrome-di=
splay-adapter-pci-id=3D11063108
+++ a/drivers/char/drm/drm_pciids.h
@@ -335,7 +335,7 @@
 	{0x1106, 0x3118, PCI_ANY_ID, PCI_ANY_ID, 0, 0, VIA_PRO_GROUP_A}, \
 	{0x1106, 0x3122, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0}, \
 	{0x1106, 0x7205, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0}, \
-	{0x1106, 0x3108, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0}, \
+	{0x1106, 0x3108, PCI_ANY_ID, PCI_ANY_ID, 0, 0, VIA_PRO_GROUP_A}, \
 	{0x1106, 0x3344, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0}, \
 	{0x1106, 0x3343, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0}, \
 	{0x1106, 0x3230, PCI_ANY_ID, PCI_ANY_ID, 0, 0, VIA_DX9_0}, \
_

Patches currently in -mm which might be from nm127@freemail.hu are

git-drm.patch
git-leds.patch
drm-change-the-type-of-unichrome-display-adapter-pci-id=3D11063108.patc=
h

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
