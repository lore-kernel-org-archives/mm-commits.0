From: akpm@linux-foundation.org
Subject: [merged] init-do_mounts-better-syntax-description.patch removed
 from -mm tree
Date: Fri, 29 Aug 2014 11:28:31 -0700
Message-ID: <5400c64f.rYk/vmrBAlI/tR/7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45027 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752913AbaH2S2c (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 29 Aug 2014 14:28:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pavel@ucw.cz, pavel@denx.de, mm-commits@vger.kernel.org


The patch titled
     Subject: init/do_mounts: better syntax description
has been removed from the -mm tree.  Its filename was
     init-do_mounts-better-syntax-description.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Pavel Machek <pavel@ucw.cz>
Subject: init/do_mounts: better syntax description

Specify hex device number unambiguously.

Signed-off-by: Pavel Machek <pavel@denx.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/do_mounts.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN init/do_mounts.c~init-do_mounts-better-syntax-description init/do_mounts.c
--- a/init/do_mounts.c~init-do_mounts-better-syntax-description
+++ a/init/do_mounts.c
@@ -182,7 +182,8 @@ done:
 /*
  *	Convert a name into device number.  We accept the following variants:
  *
- *	1) device number in hexadecimal	represents itself
+ *	1) <hex_major><hex_minor> device number in hexadecimal represents itself
+ *         no leading 0x, for example b302.
  *	2) /dev/nfs represents Root_NFS (0xff)
  *	3) /dev/<disk_name> represents the device number of disk
  *	4) /dev/<disk_name><decimal> represents the device number
_

Patches currently in -mm which might be from pavel@ucw.cz are

input-route-kbd-leds-through-the-generic-leds-layer.patch
lib-vsprintf-add-%pt-format-specifier.patch
linux-next.patch

