From: akpm@linux-foundation.org
Subject: + maintainers-add-linux-api-for-review-of-api-abi-changes.patch
 added to -mm tree
Date: Tue, 06 May 2014 14:03:53 -0700
Message-ID: <53694e39.Y1sbUHY80tSRkM7u%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41091 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754960AbaEFVDy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 May 2014 17:03:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rostedt@goodmis.org, joe@perches.com, gregkh@linuxfoundation.org, davem@davemloft.net, josh@joshtriplett.org

Subject: + maintainers-add-linux-api-for-review-of-api-abi-changes.patch added to -mm tree
To: josh@joshtriplett.org,davem@davemloft.net,gregkh@linuxfoundation.org,joe@perches.com,rostedt@goodmis.org
From: akpm@linux-foundation.org
Date: Tue, 06 May 2014 14:03:53 -0700


The patch titled
     Subject: MAINTAINERS: add linux-api for review of API/ABI changes
has been added to the -mm tree.  Its filename is
     maintainers-add-linux-api-for-review-of-api-abi-changes.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/maintainers-add-linux-api-for-review-of-api-abi-changes.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/maintainers-add-linux-api-for-review-of-api-abi-changes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Josh Triplett <josh@joshtriplett.org>
Subject: MAINTAINERS: add linux-api for review of API/ABI changes

This makes it more likely that patch submitters will CC API/ABI changes to
the linux-api list, and tools like get_maintainer.pl will do so
automatically.

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
Acked-by: Steven Rostedt <rostedt@goodmis.org>
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

maintainers-add-linux-api-for-review-of-api-abi-changes.patch
linux-next.patch

