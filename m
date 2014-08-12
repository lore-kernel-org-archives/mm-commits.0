From: akpm@linux-foundation.org
Subject: [merged] maintainers-remove-unusd-arm-qualcomm-msm-pattern.patch
 removed from -mm tree
Date: Tue, 12 Aug 2014 12:43:25 -0700
Message-ID: <53ea6e5d.hXA+MGCekDIbcIly%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f201.google.com ([209.85.214.201]:52184 "EHLO
	mail-ob0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755018AbaHLTn0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Aug 2014 15:43:26 -0400
Received: by mail-ob0-f201.google.com with SMTP id nu7so1921209obb.0
        for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2014 12:43:26 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, sboyd@codeaurora.org, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: remove unusd ARM/QUALCOMM MSM pattern
has been removed from the -mm tree.  Its filename was
     maintainers-remove-unusd-arm-qualcomm-msm-pattern.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: MAINTAINERS: remove unusd ARM/QUALCOMM MSM pattern

Commit 87933a68dce6 ("mfd: pm8921: Remove pm8xxx API now that sub-devices
use regmap") removed the file, remove the pattern.

Signed-off-by: Joe Perches <joe@perches.com>
Reviewed-by: Stephen Boyd <sboyd@codeaurora.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 -
 1 file changed, 1 deletion(-)

diff -puN MAINTAINERS~maintainers-remove-unusd-arm-qualcomm-msm-pattern MAINTAINERS
--- a/MAINTAINERS~maintainers-remove-unusd-arm-qualcomm-msm-pattern
+++ a/MAINTAINERS
@@ -1179,7 +1179,6 @@ F:	drivers/tty/serial/msm_serial.h
 F:	drivers/tty/serial/msm_serial.c
 F:	drivers/*/pm8???-*
 F:	drivers/mfd/ssbi.c
-F:	include/linux/mfd/pm8xxx/
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/davidb/linux-msm.git
 S:	Maintained
 
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
mm-utilc-add-kstrimdup.patch
fs-isofs-logging-clean-up.patch
linux-next.patch

