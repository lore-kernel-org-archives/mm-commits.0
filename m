From: akpm@linux-foundation.org
Subject: [merged] drivers-media-video-ov9640c-fix-missing-break.patch removed from -mm tree
Date: Tue, 31 Jul 2012 11:55:22 -0700
Message-ID: <20120731185523.3428C20004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:34651 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756389Ab2GaSzZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 31 Jul 2012 14:55:25 -0400
Received: by wibhr14 with SMTP id hr14so147224wib.1
        for <mm-commits@vger.kernel.org>; Tue, 31 Jul 2012 11:55:24 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@linux.intel.com, dcb314@hotmail.com, g.liakhovetski@gmx.de, hans.verkuil@cisco.com, mchehab@infradead.org, t.stanislaws@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/media/video/ov9640.c: fix missing break
has been removed from the -mm tree.  Its filename was
     drivers-media-video-ov9640c-fix-missing-break.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Alan Cox <alan@linux.intel.com>
Subject: drivers/media/video/ov9640.c: fix missing break

Without this rev2 ends up behaving as rev3

Addresses https://bugzilla.kernel.org/show_bug.cgi?id=44081

Reported-by: David Binderman <dcb314@hotmail.com>
Signed-off-by: Alan Cox <alan@linux.intel.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Tomasz Stanislawski <t.stanislaws@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/video/ov9640.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/media/video/ov9640.c~drivers-media-video-ov9640c-fix-missing-break drivers/media/video/ov9640.c
--- a/drivers/media/video/ov9640.c~drivers-media-video-ov9640c-fix-missing-break
+++ a/drivers/media/video/ov9640.c
@@ -605,6 +605,7 @@ static int ov9640_video_probe(struct i2c
 		devname		= "ov9640";
 		priv->model	= V4L2_IDENT_OV9640;
 		priv->revision	= 2;
+		break;
 	case OV9640_V3:
 		devname		= "ov9640";
 		priv->model	= V4L2_IDENT_OV9640;
_

Patches currently in -mm which might be from alan@linux.intel.com are

origin.patch
linux-next.patch
ppc-e500_tlb-memset-clears-nothing.patch

