From: akpm@linux-foundation.org
Subject: [folded-merged] drm-use-set_memoryh-header-fix.patch removed from -mm tree
Date: Mon, 08 May 2017 15:40:10 -0700
Message-ID: <5910f3ca.xa+/guIhmsi1Jfa1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42060 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751115AbdEHWkL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 8 May 2017 18:40:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, labbott@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drm-use-set_memoryh-header-fix
has been removed from the -mm tree.  Its filename was
     drm-use-set_memoryh-header-fix.patch

This patch was dropped because it was folded into drm-use-set_memoryh-header.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: drm-use-set_memoryh-header-fix

track drivers/gpu/drm/i915/i915_gem_gtt.c linux-next changes

Cc: Laura Abbott <labbott@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/i915/i915_gem_gtt.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/gpu/drm/i915/i915_gem_gtt.c~drm-use-set_memoryh-header-fix drivers/gpu/drm/i915/i915_gem_gtt.c
--- a/drivers/gpu/drm/i915/i915_gem_gtt.c~drm-use-set_memoryh-header-fix
+++ a/drivers/gpu/drm/i915/i915_gem_gtt.c
@@ -31,6 +31,8 @@
 #include <linux/seq_file.h>
 #include <linux/stop_machine.h>
 
+#include <asm/set_memory.h>
+
 #include <drm/drmP.h>
 #include <drm/i915_drm.h>
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

drm-use-set_memoryh-header.patch
drivers-staging-media-atomisp-pci-atomisp2-use-set_memoryh.patch
docs-vm-transhuge-fix-few-trivial-typos-fix.patch
dax-add-tracepoint-to-dax_writeback_one-fix.patch
drivers-staging-ccree-ssi_hashc-fix-build-with-gcc-444.patch

