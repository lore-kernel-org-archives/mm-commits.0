From: akpm@linux-foundation.org
Subject: [merged] maintainers-add-aslr-maintainer.patch removed from -mm tree
Date: Tue, 01 Nov 2011 14:14:42 -0700
Message-ID: <201111012114.pA1LEgxG014913@wpaz24.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:16413 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752436Ab1KAVPB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Nov 2011 17:15:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jkosina@suse.cz, jwboyer@redhat.com, mingo@elte.hu, nicolas.pitre@linaro.org, rmk@arm.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: add ASLR maintainer
has been removed from the -mm tree.  Its filename was
     maintainers-add-aslr-maintainer.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Jiri Kosina <jkosina@suse.cz>
Subject: MAINTAINERS: add ASLR maintainer

Since achieving the full ASLR by merging the PIE randomization in commit
cc503c1b43 ("x86: PIE executable randomization"), I have been dealing with
most (if not all) of the bugreports reported against userspace address
space randomization, so it might be a good idea to provide a decent
contact point in MAINTAINERS.

Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Cc: Josh Boyer <jwboyer@redhat.com>
Cc: Nicolas Pitre <nicolas.pitre@linaro.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN MAINTAINERS~maintainers-add-aslr-maintainer MAINTAINERS
--- a/MAINTAINERS~maintainers-add-aslr-maintainer
+++ a/MAINTAINERS
@@ -316,6 +316,10 @@ W:	http://wiki.analog.com/AD7879
 S:	Supported
 F:	drivers/input/touchscreen/ad7879.c
 
+ADDRESS SPACE LAYOUT RANDOMIZATION (ASLR)
+M:	Jiri Kosina <jkosina@suse.cz>
+S:	Maintained
+
 ADM1025 HARDWARE MONITOR DRIVER
 M:	Jean Delvare <khali@linux-fr.org>
 L:	lm-sensors@lm-sensors.org
_

Patches currently in -mm which might be from jkosina@suse.cz are

origin.patch
linux-next.patch
binfmt_elf-fix-pie-execution-with-randomization-disabled.patch

