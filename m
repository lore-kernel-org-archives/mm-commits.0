From: akpm@linux-foundation.org
Subject: - rapidio-fix-docbook-references.patch removed from -mm tree
Date: Wed, 30 Apr 2008 15:25:35 -0700
Message-ID: <200804302225.m3UMPZQZ006705@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39860 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761886AbYD3W0T (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 18:26:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, galak@gate.crashing.org, mporter@kernel.crashing.org, wei.zhang@freescale.com, mm-commits@vger.kernel.org


The patch titled
     rapidio: docbook fixes
has been removed from the -mm tree.  Its filename was
     rapidio-fix-docbook-references.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rapidio: docbook fixes
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix header file kernel-doc.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Acked-by: Zhang Wei <wei.zhang@freescale.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/rio.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN include/linux/rio.h~rapidio-fix-docbook-references include/linux/rio.h
--- a/include/linux/rio.h~rapidio-fix-docbook-references
+++ a/include/linux/rio.h
@@ -325,7 +325,7 @@ struct rio_route_ops {
 };
 
 /**
- * Struct for RIO memory definition.
+ * struct rio_mem - struct for RIO memory definition.
  * @node: Node in list of memories
  * @virt: The virtual address for mapped memory accessing.
  * @owner: The owner id of this memory.
@@ -344,7 +344,7 @@ struct rio_mem {
 };
 
 /**
- * Struct for RIO memory definition.
+ * struct rio_mem_ops - Struct for RIO memory operations definition.
  * @map_inb: The function for mapping inbound memory window.
  * @map_outb: The function for mapping outbound memory window.
  * @unmap_inb: The function for unmapping inbound memory window.
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
basic-braille-screen-reader-support.patch
add-macros-similar-to-min-max-min_t-max_t.patch
infrastructure-to-debug-dynamic-objects.patch
debugobjects-add-documentation.patch
debugobjects-add-timer-specific-object-debugging-code.patch
add-hrtimer-specific-debugobjects-code.patch
sysfs-sysfs_update_group-stub-for-config_sysfs=n.patch
docbook-fix-fatal-rapidio-yet-again-and-more-to-come.patch
docbook-fix-vmalloc-missing-parameter-notation.patch
pnp-fix-printk-format-warnings.patch
pnp-fix-printk-format-warnings-fix.patch
pnp-fix-printk-format-warnings-fix-checkpatch-fixes.patch
x86-fix-setup-printk-format-warning.patch
rapidio-fix-docbook-references.patch
rapidio-fix-kernel-doc-problems.patch
git-kvm.patch
8390-split-8390-support-into-a-pausing-and-a-non-pausing-driver-core.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
git-ocfs2.patch
git-unionfs.patch
fix-gregkh-usb-usb-isp1760-hcd-driver.patch
uwb-fix-kconfig-causing-undefined-references.patch
docbook-some-kernel-locking-fixes.patch
documentation-build-source-files-in-documentation-sub-dir.patch
documentation-build-source-files-in-documentation-sub-dir-disable.patch
profile-likely-unlikely-macros.patch

