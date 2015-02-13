From: akpm@linux-foundation.org
Subject: [folded-merged]
 kasan-enable-instrumentation-of-global-variables-fix-2.patch removed from
 -mm tree
Date: Fri, 13 Feb 2015 14:30:08 -0800
Message-ID: <54de7af0.Nri/ui/y8YQDIRAg%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51204 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752758AbbBMWaJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Feb 2015 17:30:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: a.ryabinin@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kasan-enable-instrumentation-of-global-variables-fix-2
has been removed from the -mm tree.  Its filename was
     kasan-enable-instrumentation-of-global-variables-fix-2.patch

This patch was dropped because it was folded into kasan-enable-instrumentation-of-global-variables.patch

------------------------------------------------------
From: Andrey Ryabinin <a.ryabinin@samsung.com>
Subject: kasan-enable-instrumentation-of-global-variables-fix-2

Disable broken globals instrumentation for GCC 4.9.2

Signed-off-by: Andrey Ryabinin <a.ryabinin@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/Makefile.kasan |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN scripts/Makefile.kasan~kasan-enable-instrumentation-of-global-variables-fix-2 scripts/Makefile.kasan
--- a/scripts/Makefile.kasan~kasan-enable-instrumentation-of-global-variables-fix-2
+++ a/scripts/Makefile.kasan
@@ -5,7 +5,7 @@ else
 	call_threshold := 0
 endif
 
-CFLAGS_KASAN_MINIMAL := -fsanitize=kernel-address --param asan-globals=1
+CFLAGS_KASAN_MINIMAL := -fsanitize=kernel-address
 
 CFLAGS_KASAN := $(call cc-option, -fsanitize=kernel-address \
 		-fasan-shadow-offset=$(CONFIG_KASAN_SHADOW_OFFSET) \
_

Patches currently in -mm which might be from a.ryabinin@samsung.com are

origin.patch
module_device_table-fix-some-callsites.patch
compiler-introduce-__aliassymbol-shortcut.patch
add-kernel-address-sanitizer-infrastructure.patch
kasan-disable-memory-hotplug.patch
x86_64-add-kasan-support.patch
mm-page_alloc-add-kasan-hooks-on-alloc-and-free-paths.patch
mm-slub-introduce-virt_to_obj-function.patch
mm-slub-share-object_err-function.patch
mm-slub-introduce-metadata_access_enable-metadata_access_disable.patch
mm-slub-add-kernel-address-sanitizer-support-for-slub-allocator.patch
fs-dcache-manually-unpoison-dname-after-allocation-to-shut-up-kasans-reports.patch
kmemleak-disable-kasan-instrumentation-for-kmemleak.patch
lib-add-kasan-test-module.patch
x86_64-kasan-add-interceptors-for-memset-memmove-memcpy-functions.patch
kasan-enable-stack-instrumentation.patch
mm-vmalloc-add-flag-preventing-guard-hole-allocation.patch
mm-vmalloc-pass-additional-vm_flags-to-__vmalloc_node_range.patch
kernel-add-support-for-init_array-constructors.patch
module-fix-types-of-device-tables-aliases.patch
kasan-enable-instrumentation-of-global-variables.patch
kasan-enable-instrumentation-of-global-variables-fix-2-fix.patch

