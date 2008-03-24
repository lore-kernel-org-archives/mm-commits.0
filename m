From: akpm@linux-foundation.org
Subject: - bttv-add-a-radio-compat_ioctl-file-operation.patch removed from -mm tree
Date: Mon, 24 Mar 2008 14:44:33 -0700
Message-ID: <200803242144.m2OLiYMX026688@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38993 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752760AbYCXVp4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 24 Mar 2008 17:45:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: robfitz@273k.net, bonganilinux@mweb.co.za, hverkuil@xs4all.nl, mchehab@infradead.org, mkrufky@linuxtv.org, nshmyrev@yandex.ru, xyzzy@speakeasy.org, mm-commits@vger.kernel.org


The patch titled
     bttv: add a radio compat_ioctl file operation
has been removed from the -mm tree.  Its filename was
     bttv-add-a-radio-compat_ioctl-file-operation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: bttv: add a radio compat_ioctl file operation
From: Robert Fitzsimons <robfitz@273k.net>

Signed-off-by: Robert Fitzsimons <robfitz@273k.net>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Trent Piepho <xyzzy@speakeasy.org>
Cc: Nickolay V. Shmyrev <nshmyrev@yandex.ru>
Cc: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Michael Krufky <mkrufky@linuxtv.org>
Cc: Bongani Hlope <bonganilinux@mweb.co.za>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/video/bt8xx/bttv-driver.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/media/video/bt8xx/bttv-driver.c~bttv-add-a-radio-compat_ioctl-file-operation drivers/media/video/bt8xx/bttv-driver.c
--- a/drivers/media/video/bt8xx/bttv-driver.c~bttv-add-a-radio-compat_ioctl-file-operation
+++ a/drivers/media/video/bt8xx/bttv-driver.c
@@ -3613,6 +3613,7 @@ static const struct file_operations radi
 	.release  = radio_release,
 	.compat_ioctl	= v4l_compat_ioctl32,
 	.ioctl	  = video_ioctl2,
+	.compat_ioctl	= v4l_compat_ioctl32,
 	.llseek	  = no_llseek,
 	.poll     = radio_poll,
 };
_

Patches currently in -mm which might be from robfitz@273k.net are

git-dvb.patch
bttv-add-a-radio-compat_ioctl-file-operation.patch

