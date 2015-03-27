From: akpm@linux-foundation.org
Subject: [merged]
 maintainers-add-myself-as-dmi-smbios-support-maintainer.patch removed from
 -mm tree
Date: Fri, 27 Mar 2015 11:17:01 -0700
Message-ID: <55159e9d.D4u9OX1e/V0jTdSO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47725 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753361AbbC0SRB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 27 Mar 2015 14:17:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdelvare@suse.de, matt.fleming@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: add Jan as DMI/SMBIOS support maintainer
has been removed from the -mm tree.  Its filename was
     maintainers-add-myself-as-dmi-smbios-support-maintainer.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jean Delvare <jdelvare@suse.de>
Subject: MAINTAINERS: add Jan as DMI/SMBIOS support maintainer

I am familiar with these drivers and I care about them so let me add
myself as their maintainer.

Signed-off-by: Jean Delvare <jdelvare@suse.de>
Acked-by: Matt Fleming <matt.fleming@intel.com>
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

origin.patch
fork_init-update-max_threads-comment.patch
linux-next.patch

