From: akpm@linux-foundation.org
Subject: - sysfs-fix-a-copy-n-paste-typo-in-comment.patch removed from -mm tree
Date: Tue, 15 Jan 2008 17:39:13 -0800
Message-ID: <200801160139.m0G1dD9J013989@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45435 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754167AbYAPBtB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Jan 2008 20:49:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: khali@linux-fr.org, mm-commits@vger.kernel.org


The patch titled
     sysfs: fix a copy-n-paste typo in comment
has been removed from the -mm tree.  Its filename was
     sysfs-fix-a-copy-n-paste-typo-in-comment.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sysfs: fix a copy-n-paste typo in comment
From: Jean Delvare <khali@linux-fr.org>

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/sysfs/dir.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/sysfs/dir.c~sysfs-fix-a-copy-n-paste-typo-in-comment fs/sysfs/dir.c
--- a/fs/sysfs/dir.c~sysfs-fix-a-copy-n-paste-typo-in-comment
+++ a/fs/sysfs/dir.c
@@ -440,7 +440,7 @@ int sysfs_add_one(struct sysfs_addrm_cxt
 /**
  *	sysfs_remove_one - remove sysfs_dirent from parent
  *	@acxt: addrm context to use
- *	@sd: sysfs_dirent to be added
+ *	@sd: sysfs_dirent to be removed
  *
  *	Mark @sd removed and drop nlink of parent inode if @sd is a
  *	directory.  @sd is unlinked from the children list.
_

Patches currently in -mm which might be from khali@linux-fr.org are

origin.patch
small-acpica-extension-to-be-able-to-store-the-name-of.patch
export-acpi_check_resource_conflict.patch
mm-only-enforce-acpi-resource-conflict-checks.patch
git-arm.patch
git-dvb.patch
fix-jdelvare-i2c-i2c-constify-client-address-data.patch
oz99x-i2c-button-and-led-support-driver.patch
oz99x-i2c-button-and-led-support-driver-update.patch
i2c-isp1301_omap-new-style-i2c-driver-updates-part-1.patch
i2c-isp1301_omap-new-style-i2c-driver-updates-part-2.patch
git-hwmon.patch
hwmon-new-chip-driver-for-ti-ads7828-a-d.patch
hwmon-new-chip-driver-for-ti-ads7828-a-d-checkpatch-fixes.patch
hwmon-new-chip-driver-for-ti-ads7828-a-d-update.patch
rtc-pcf8583-dont-abuse-i2c_m_nostart.patch
rtc-add-support-for-the-s-35390a-rtc-chip.patch
rtc-add-support-for-the-s-35390a-rtc-chip-update.patch
rtc-add-support-for-the-s-35390a-rtc-chip-update2.patch
gpiolib-add-drivers-gpio-directory.patch
gpiolib-add-gpio-provider-infrastructure.patch
gpiolib-update-documentation-gpiotxt.patch
gpiolib-pxa-platform-support.patch
gpiolib-pcf857x-i2c-gpio-expander-support.patch
gpiolib-mcp23s08-spi-gpio-expander-support.patch
gpiolib-pca9539-i2c-gpio-expander-support.patch
gpiolib-deprecate-obsolete-pca9539-driver.patch
gpiolib-avr32-at32ap-platform-support.patch
