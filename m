From: akpm@linux-foundation.org
Subject: + drivers-media-video-ov9640c-fix-missing-break.patch added to -mm tree
Date: Tue, 24 Jul 2012 14:11:47 -0700
Message-ID: <20120724211148.079F7200057@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f74.google.com ([209.85.214.74]:57341 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932067Ab2GXVLu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 24 Jul 2012 17:11:50 -0400
Received: by bkcjc3 with SMTP id jc3so576bkc.1
        for <mm-commits@vger.kernel.org>; Tue, 24 Jul 2012 14:11:49 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@linux.intel.com, dcb314@hotmail.com, g.liakhovetski@gmx.de, hans.verkuil@cisco.com, mchehab@infradead.org, t.stanislaws@samsung.com


The patch titled
     Subject: drivers/media/video/ov9640.c: fix missing break
has been added to the -mm tree.  Its filename is
     drivers-media-video-ov9640c-fix-missing-break.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Subject: Subject: drivers/media/video/ov9640.c: fix missing break

Patches currently in -mm which might be from alan@linux.intel.com are

origin.patch
linux-next.patch
ppc-e500_tlb-memset-clears-nothing.patch
drivers-media-dvb-dvb-usb-az6007c-fix-incorrect-memcpy.patch
drivers-media-video-cx25821-cx25821-medusa-videoc-incorrect-check-on-decoder-type.patch
drivers-media-video-ov9640c-fix-missing-break.patch
fs-make-dumpable=2-require-fully-qualified-path.patch
coredump-warn-about-unsafe-suid_dumpable-core_pattern-combo.patch
kernel-sysc-avoid-argv_freenull.patch
drivers-message-i2o-i2o_procc-the-pointer-returned-from-chtostr-points-to-an-array-which-is-no-longer-valid.patch

