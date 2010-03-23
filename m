From: akpm@linux-foundation.org
Subject: [merged] drivers-gpu-drm-i915-intel_biosc-fix-continuation-line-formats.patch removed from -mm tree
Date: Tue, 23 Mar 2010 12:01:57 -0400
Message-ID: <201003231902.o2NJ2n2b020112@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43238 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753406Ab0CWTDx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 23 Mar 2010 15:03:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, airlied@linux.ie, eric@anholt.net, jbarnes@virtuousgeek.org, mm-commits@vger.kernel.org


The patch titled
     drivers/gpu/drm/i915/intel_bios.c: fix continuation line formats
has been removed from the -mm tree.  Its filename was
     drivers-gpu-drm-i915-intel_biosc-fix-continuation-line-formats.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/gpu/drm/i915/intel_bios.c: fix continuation line formats
From: Joe Perches <joe@perches.com>

String constants that are continued on subsequent lines with \ will cause
spurious whitespace in the resulting output.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Dave Airlie <airlied@linux.ie>
Cc: Eric Anholt <eric@anholt.net>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/i915/intel_bios.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN drivers/gpu/drm/i915/intel_bios.c~drivers-gpu-drm-i915-intel_biosc-fix-continuation-line-formats drivers/gpu/drm/i915/intel_bios.c
--- a/drivers/gpu/drm/i915/intel_bios.c~drivers-gpu-drm-i915-intel_biosc-fix-continuation-line-formats
+++ a/drivers/gpu/drm/i915/intel_bios.c
@@ -417,8 +417,7 @@ parse_edp(struct drm_i915_private *dev_p
 	edp = find_section(bdb, BDB_EDP);
 	if (!edp) {
 		if (SUPPORTS_EDP(dev_priv->dev) && dev_priv->edp_support) {
-			DRM_DEBUG_KMS("No eDP BDB found but eDP panel supported,\
-				       assume 18bpp panel color depth.\n");
+			DRM_DEBUG_KMS("No eDP BDB found but eDP panel supported, assume 18bpp panel color depth.\n");
 			dev_priv->edp_bpp = 18;
 		}
 		return;
_

Patches currently in -mm which might be from joe@perches.com are

get_maintainer-repair-stdin-usage.patch
maintainers-use-tab-not-spaces-for-delimiter.patch
linux-next.patch
kernelh-fix-wrong-usage-of-__ratelimit.patch
drivers-scsi-correct-the-size-argument-to-kmalloc.patch
drivers-scsi-qla2xxx-qla_osc-fix-continuation-line-formats.patch
drivers-scsi-chc-dont-use-vprintk-as-macro.patch
vsprintfc-use-noinline_for_stack.patch

