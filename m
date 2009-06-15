From: akpm@linux-foundation.org
Subject: [merged] intelfb-fix-spelling-of-clock.patch removed from -mm tree
Date: Mon, 15 Jun 2009 12:01:26 -0700
Message-ID: <200906151901.n5FJ1QiN022851@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40050 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765168AbZFOTBq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Jun 2009 15:01:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: proski@gnu.org, airlied@linux.ie, eric@anholt.net, mm-commits@vger.kernel.org


The patch titled
     intelfb: fix spelling of "CLOCK"
has been removed from the -mm tree.  Its filename was
     intelfb-fix-spelling-of-clock.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: intelfb: fix spelling of "CLOCK"
From: Pavel Roskin <proski@gnu.org>

Signed-off-by: Pavel Roskin <proski@gnu.org>
Cc: Eric Anholt <eric@anholt.net>
Cc: Dave Airlie <airlied@linux.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/i915/intel_fb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/gpu/drm/i915/intel_fb.c~intelfb-fix-spelling-of-clock drivers/gpu/drm/i915/intel_fb.c
--- a/drivers/gpu/drm/i915/intel_fb.c~intelfb-fix-spelling-of-clock
+++ a/drivers/gpu/drm/i915/intel_fb.c
@@ -207,7 +207,7 @@ static int intelfb_set_par(struct fb_inf
 
 	if (var->pixclock != -1) {
 
-		DRM_ERROR("PIXEL CLCOK SET\n");
+		DRM_ERROR("PIXEL CLOCK SET\n");
 		return -EINVAL;
 	} else {
 		struct drm_crtc *crtc;
_

Patches currently in -mm which might be from proski@gnu.org are

origin.patch
linux-next.patch

