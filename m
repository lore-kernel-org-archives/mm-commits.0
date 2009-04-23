From: akpm@linux-foundation.org
Subject: + intelfb-fix-spelling-of-clock.patch added to -mm tree
Date: Thu, 23 Apr 2009 13:41:55 -0700
Message-ID: <200904232041.n3NKft2l031986@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48679 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757770AbZDWUpW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 23 Apr 2009 16:45:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: proski@gnu.org, airlied@linux.ie, eric@anholt.net


The patch titled
     intelfb: fix spelling of "CLOCK"
has been added to the -mm tree.  Its filename is
     intelfb-fix-spelling-of-clock.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -206,7 +206,7 @@ static int intelfb_set_par(struct fb_inf
 
 	if (var->pixclock != -1) {
 
-		DRM_ERROR("PIXEL CLCOK SET\n");
+		DRM_ERROR("PIXEL CLOCK SET\n");
 		return -EINVAL;
 	} else {
 		struct drm_crtc *crtc;
_

Patches currently in -mm which might be from proski@gnu.org are

linux-next.patch
intelfb-fix-spelling-of-clock.patch

