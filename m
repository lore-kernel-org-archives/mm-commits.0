From: akpm@linux-foundation.org
Subject: [merged]
 maintainers-add-linux-api-for-review-of-api-abi-changes.patch removed from
 -mm tree
Date: Mon, 09 Jun 2014 12:41:26 -0700
Message-ID: <53960de6.3LmbCl9xVcaMLVpK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54402 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750805AbaFITl1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jun 2014 15:41:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rostedt@goodmis.org, mtk.man-pages@gmail.com, joe@perches.com, gregkh@linuxfoundation.org, davem@davemloft.net, josh@joshtriplett.org

Subject: [merged] maintainers-add-linux-api-for-review-of-api-abi-changes.patch removed from -mm tree
To: josh@joshtriplett.org,davem@davemloft.net,gregkh@linuxfoundation.org,joe@perches.com,mtk.man-pages@gmail.com,rostedt@goodmis.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 09 Jun 2014 12:41:26 -0700


The patch titled
     Subject: MAINTAINERS: add linux-api for review of API/ABI changes
has been removed from the -mm tree.  Its filename was
     maintainers-add-linux-api-for-review-of-api-abi-changes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Josh Triplett <josh@joshtriplett.org>
Subject: MAINTAINERS: add linux-api for review of API/ABI changes

This makes it more likely that patch submitters will CC API/ABI changes to
the linux-api list, and tools like get_maintainer.pl will do so
automatically.

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
Acked-by: Steven Rostedt <rostedt@goodmis.org>
Acked-by: Michael Kerrisk <mtk.man-pages@gmail.com>
Cc: Joe Perches <joe@perches.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN MAINTAINERS~maintainers-add-linux-api-for-review-of-api-abi-changes MAINTAINERS
--- a/MAINTAINERS~maintainers-add-linux-api-for-review-of-api-abi-changes
+++ a/MAINTAINERS
@@ -210,6 +210,13 @@ S:	Supported
 F:	Documentation/scsi/aacraid.txt
 F:	drivers/scsi/aacraid/
 
+ABI/API
+L:	linux-api@vger.kernel.org
+F:	Documentation/ABI/
+F:	include/linux/syscalls.h
+F:	include/uapi/
+F:	kernel/sys_ni.c
+
 ABIT UGURU 1,2 HARDWARE MONITOR DRIVER
 M:	Hans de Goede <hdegoede@redhat.com>
 L:	lm-sensors@lm-sensors.org
_

Patches currently in -mm which might be from josh@joshtriplett.org are

origin.patch
linux-next.patch

