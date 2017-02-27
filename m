From: akpm@linux-foundation.org
Subject: [patch 06/78] autofs: remove wrong comment
Date: Mon, 27 Feb 2017 14:26:59 -0800
Message-ID: <58b4a7b3.3OvG1lpKdxdHa/oy%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44834 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751583AbdB0W3i (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 27 Feb 2017 17:29:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, tkusumi@tuxera.com, raven@themaw.net

From: Tomohiro Kusumi <tkusumi@tuxera.com>
Subject: autofs: remove wrong comment

This format seems to have been taken from device mapper header, but autofs
has no such file:function in both kernel and userspace.

Link: http://lkml.kernel.org/r/148577164094.9801.4775075118014742496.stgit@pluto.themaw.net
Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
Signed-off-by: Ian Kent <raven@themaw.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/uapi/linux/auto_dev-ioctl.h |    4 ----
 1 file changed, 4 deletions(-)

diff -puN include/uapi/linux/auto_dev-ioctl.h~autofs-remove-wrong-comment include/uapi/linux/auto_dev-ioctl.h
--- a/include/uapi/linux/auto_dev-ioctl.h~autofs-remove-wrong-comment
+++ a/include/uapi/linux/auto_dev-ioctl.h
@@ -120,10 +120,6 @@ static inline void init_autofs_dev_ioctl
 	in->ioctlfd = -1;
 }
 
-/*
- * If you change this make sure you make the corresponding change
- * to autofs-dev-ioctl.c:lookup_ioctl()
- */
 enum {
 	/* Get various version info */
 	AUTOFS_DEV_IOCTL_VERSION_CMD = 0x71,
_
