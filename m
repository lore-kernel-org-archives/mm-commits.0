From: akpm@linux-foundation.org
Subject: + maintainers-add-myself-as-dmi-smbios-support-maintainer.patch
 added to -mm tree
Date: Mon, 23 Mar 2015 16:16:32 -0700
Message-ID: <55109ed0.8BB2meIQS5G1ZT7A%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48684 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753277AbbCWXQd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 Mar 2015 19:16:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdelvare@suse.de, matt.fleming@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: add Jan as DMI/SMBIOS support maintainer
has been added to the -mm tree.  Its filename is
     maintainers-add-myself-as-dmi-smbios-support-maintainer.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/maintainers-add-myself-as-dmi-smbios-support-maintainer.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/maintainers-add-myself-as-dmi-smbios-support-maintainer.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jean Delvare <jdelvare@suse.de>
Subject: MAINTAINERS: add Jan as DMI/SMBIOS support maintainer

I am familiar with these drivers and I care about them so let me add
myself as their maintainer.

Signed-off-by: Jean Delvare <jdelvare@suse.de>
Cc: Matt Fleming <matt.fleming@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN MAINTAINERS~maintainers-add-myself-as-dmi-smbios-support-maintainer MAINTAINERS
--- a/MAINTAINERS~maintainers-add-myself-as-dmi-smbios-support-maintainer
+++ a/MAINTAINERS
@@ -3252,6 +3252,13 @@ S:	Maintained
 F:	Documentation/hwmon/dme1737
 F:	drivers/hwmon/dme1737.c
 
+DMI/SMBIOS SUPPORT
+M:	Jean Delvare <jdelvare@suse.de>
+S:	Maintained
+F:	drivers/firmware/dmi-id.c
+F:	drivers/firmware/dmi_scan.c
+F:	include/linux/dmi.h
+
 DOCKING STATION DRIVER
 M:	Shaohua Li <shaohua.li@intel.com>
 L:	linux-acpi@vger.kernel.org
_

Patches currently in -mm which might be from jdelvare@suse.de are

maintainers-add-myself-as-dmi-smbios-support-maintainer.patch
fork_init-update-max_threads-comment.patch
linux-next.patch

