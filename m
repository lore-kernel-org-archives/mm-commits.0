From: akpm@linux-foundation.org
Subject: - enable-hotplug-memory-remove-for-ppc64.patch removed from -mm tree
Date: Fri, 15 Feb 2008 23:34:59 -0800
Message-ID: <200802160735.m1G7YxZb014386@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39565 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751234AbYBPHfe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 16 Feb 2008 02:35:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pbadari@us.ibm.com, benh@kernel.crashing.org, galak@gate.crashing.org, haveblue@us.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, paulus@samba.org, mm-commits@vger.kernel.org


The patch titled
     Enable hotplug memory remove for ppc64
has been removed from the -mm tree.  Its filename was
     enable-hotplug-memory-remove-for-ppc64.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Enable hotplug memory remove for ppc64
From: Badari Pulavarty <pbadari@us.ibm.com>

Enable hotplug memory remove for ppc64.

Signed-off-by: Badari Pulavarty <pbadari@us.ibm.com>
Cc: Dave Hansen <haveblue@us.ibm.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Kumar Gala <galak@gate.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/Kconfig |    3 +++
 1 file changed, 3 insertions(+)

diff -puN arch/powerpc/Kconfig~enable-hotplug-memory-remove-for-ppc64 arch/powerpc/Kconfig
--- a/arch/powerpc/Kconfig~enable-hotplug-memory-remove-for-ppc64
+++ a/arch/powerpc/Kconfig
@@ -279,6 +279,9 @@ config ARCH_HAS_WALK_MEMORY
 config ARCH_ENABLE_MEMORY_HOTREMOVE
 	def_bool y
 
+config ARCH_ENABLE_MEMORY_HOTREMOVE
+	def_bool y
+
 config KEXEC
 	bool "kexec system call (EXPERIMENTAL)"
 	depends on (PPC_PRPMC2800 || PPC_MULTIPLATFORM) && EXPERIMENTAL
_

Patches currently in -mm which might be from pbadari@us.ibm.com are

enable-hotplug-memory-remove-for-ppc64.patch
register_memory-unregister_memory-fix-use-after-free-and-refcounting.patch
fix-invalidate_inode_pages2_range-to-not-clear-ret.patch
memory-hotplug-add-removable-to-sysfs-to-show-memblock-removability.patch
