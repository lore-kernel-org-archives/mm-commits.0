From: akpm@linux-foundation.org
Subject: [folded-dropped] drm-convert-to-idr_alloc-fix-fix.patch removed from -mm tree
Date: Wed, 27 Feb 2013 16:43:45 -0800
Message-ID: <20130228004345.DEDE95A408F@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f73.google.com ([209.85.128.73]:55110 "EHLO
	mail-qe0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752497Ab3B1Anr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 27 Feb 2013 19:43:47 -0500
Received: by mail-qe0-f73.google.com with SMTP id a11so139500qen.4
        for <mm-commits@vger.kernel.org>; Wed, 27 Feb 2013 16:43:46 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jslaby@suse.cz, airlied@linux.ie, artem.savkov@gmail.com, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: drm-convert-to-idr_alloc-fix-fix
has been removed from the -mm tree.  Its filename was
     drm-convert-to-idr_alloc-fix-fix.patch

This patch was dropped because it was folded into drm-convert-to-idr_alloc.patch

------------------------------------------------------
From: Jiri Slaby <jslaby@suse.cz>
Subject: drm-convert-to-idr_alloc-fix-fix

fix drm_gem_flink_ioctl() return value

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Artem Savkov <artem.savkov@gmail.com>
Cc: David Airlie <airlied@linux.ie>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/drm_gem.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/gpu/drm/drm_gem.c~drm-convert-to-idr_alloc-fix-fix drivers/gpu/drm/drm_gem.c
--- a/drivers/gpu/drm/drm_gem.c~drm-convert-to-idr_alloc-fix-fix
+++ a/drivers/gpu/drm/drm_gem.c
@@ -460,6 +460,7 @@ drm_gem_flink_ioctl(struct drm_device *d
 
 		if (ret < 0)
 			goto err;
+		ret = 0;
 
 		/* Allocate a reference for the name table.  */
 		drm_gem_object_reference(obj);
_

Patches currently in -mm which might be from jslaby@suse.cz are

origin.patch
drm-convert-to-idr_alloc.patch

