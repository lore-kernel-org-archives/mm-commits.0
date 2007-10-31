From: akpm@linux-foundation.org
Subject: + enable-hotplug-memory-remove-for-ppc64.patch added to -mm tree
Date: Wed, 31 Oct 2007 15:33:53 -0700
Message-ID: <200710312233.l9VMXrP3032451@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55640 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752940AbXJaWed (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 31 Oct 2007 18:34:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: pbadari@us.ibm.com, benh@kernel.crashing.org, galak@gate.crashing.org, haveblue@us.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, paulus@samba.org


The patch titled
     Enable hotplug memory remove for ppc64
has been added to the -mm tree.  Its filename is
     enable-hotplug-memory-remove-for-ppc64.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -236,6 +236,9 @@ config HOTPLUG_CPU
 config ARCH_ENABLE_MEMORY_HOTPLUG
 	def_bool y
 
+config ARCH_ENABLE_MEMORY_HOTREMOVE
+	def_bool y
+
 config KEXEC
 	bool "kexec system call (EXPERIMENTAL)"
 	depends on (PPC_PRPMC2800 || PPC_MULTIPLATFORM) && EXPERIMENTAL
_

Patches currently in -mm which might be from pbadari@us.ibm.com are

powerpc-move-_rtc_time-routines-under-config_adb_cuda.patch
hugetlb-allow-sticky-directory-mount-option.patch
memory-hotplug-add-removable-to-sysfs-to-show-memblock-removability.patch
add-remove_memory-for-ppc64.patch
add-remove_memory-for-ppc64-fix.patch
enable-hotplug-memory-remove-for-ppc64.patch
add-arch-specific-walk_memory_remove-for-ppc64.patch
mem-controller-gfp-mask-fix.patch
