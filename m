From: akpm@linux-foundation.org
Subject: + edac-pasemi_edac-needs-to-include-linux-edach.patch added to -mm tree
Date: Tue, 29 Apr 2008 18:30:03 -0700
Message-ID: <200804300130.m3U1U3Q7020248@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57689 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754164AbYD3BaQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Apr 2008 21:30:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sfr@canb.auug.org.au, dougthompson@xmission.com, h.mitake@gmail.com, olof@lixom.net


The patch titled
     edac: pasemi_edac needs to include linux/edac.h
has been added to the -mm tree.  Its filename is
     edac-pasemi_edac-needs-to-include-linux-edach.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: edac: pasemi_edac needs to include linux/edac.h
From: Stephen Rothwell <sfr@canb.auug.org.au>

Commit c3c52bce6993c6d37af2c2de9b482a7013d646a7 ("edac: fix module
initialization on several modules 2nd time") added a call to opstate_init
but did not include linux/edac.h that declares it.

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Hitoshi Mitake <h.mitake@gmail.com>
Cc: Olof Johansson <olof@lixom.net>
Cc: Doug Thompson <dougthompson@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/edac/pasemi_edac.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/edac/pasemi_edac.c~edac-pasemi_edac-needs-to-include-linux-edach drivers/edac/pasemi_edac.c
--- a/drivers/edac/pasemi_edac.c~edac-pasemi_edac-needs-to-include-linux-edach
+++ a/drivers/edac/pasemi_edac.c
@@ -26,6 +26,7 @@
 #include <linux/pci.h>
 #include <linux/pci_ids.h>
 #include <linux/slab.h>
+#include <linux/edac.h>
 #include "edac_core.h"
 
 #define MODULE_NAME "pasemi_edac"
_

Patches currently in -mm which might be from sfr@canb.auug.org.au are

origin.patch
edac-pasemi_edac-needs-to-include-linux-edach.patch
git-kvm.patch
smsc-ircc2-wrap-pnp-probe-code-in-ifdef-config_pnp.patch
nsc-ircc-wrap-pnp-probe-code-in-ifdef-config_pnp.patch
git-xfs.patch
viocons-bkl-locking.patch
consoles-switch-to-int-put_char-method.patch

