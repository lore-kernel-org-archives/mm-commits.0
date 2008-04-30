From: akpm@linux-foundation.org
Subject: - edac-pasemi_edac-needs-to-include-linux-edach.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:50:42 -0700
Message-ID: <200804300550.m3U5oget030146@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41117 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759117AbYD3Fuu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 01:50:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sfr@canb.auug.org.au, dougthompson@xmission.com, h.mitake@gmail.com, olof@lixom.net, mm-commits@vger.kernel.org


The patch titled
     edac: pasemi_edac needs to include linux/edac.h
has been removed from the -mm tree.  Its filename was
     edac-pasemi_edac-needs-to-include-linux-edach.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
git-kvm.patch
smsc-ircc2-wrap-pnp-probe-code-in-ifdef-config_pnp.patch
nsc-ircc-wrap-pnp-probe-code-in-ifdef-config_pnp.patch
git-xfs.patch
viocons-bkl-locking.patch
consoles-switch-to-int-put_char-method.patch

