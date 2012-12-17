From: akpm@linux-foundation.org
Subject: [folded-merged] backlight-88pm860x_bl-remove-an-unnecessary-line-continuation-fix.patch removed from -mm tree
Date: Mon, 17 Dec 2012 15:44:08 -0800
Message-ID: <20121217234409.0C82820004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f74.google.com ([209.85.214.74]:50136 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752646Ab2LQXoL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 17 Dec 2012 18:44:11 -0500
Received: by mail-bk0-f74.google.com with SMTP id je9so352237bkc.3
        for <mm-commits@vger.kernel.org>; Mon, 17 Dec 2012 15:44:10 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: backlight-88pm860x_bl-remove-an-unnecessary-line-continuation-fix
has been removed from the -mm tree.  Its filename was
     backlight-88pm860x_bl-remove-an-unnecessary-line-continuation-fix.patch

This patch was dropped because it was folded into backlight-88pm860x_bl-remove-an-unnecessary-line-continuation.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: backlight-88pm860x_bl-remove-an-unnecessary-line-continuation-fix

remove newline

Cc: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/88pm860x_bl.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN drivers/video/backlight/88pm860x_bl.c~backlight-88pm860x_bl-remove-an-unnecessary-line-continuation-fix drivers/video/backlight/88pm860x_bl.c
--- a/drivers/video/backlight/88pm860x_bl.c~backlight-88pm860x_bl-remove-an-unnecessary-line-continuation-fix
+++ a/drivers/video/backlight/88pm860x_bl.c
@@ -228,8 +228,7 @@ static int pm860x_backlight_probe(struct
 	sprintf(name, "backlight-%d", pdev->id);
 	data->port = pdev->id;
 	data->chip = chip;
-	data->i2c = (chip->id == CHIP_PM8606) ? chip->client
-			: chip->companion;
+	data->i2c = (chip->id == CHIP_PM8606) ? chip->client : chip->companion;
 	data->current_brightness = MAX_BRIGHTNESS;
 	if (pm860x_backlight_dt_init(pdev, data, name)) {
 		if (pdata) {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
create-non-empty-arch-x86-include-uapi-asm-files.patch
mm-memoryc-suppress-warning.patch
lseek-the-whence-argument-is-called-whence.patch
drivers-video-backlight-lp855x_blc-use-generic-pwm-functions.patch
backlight-add-of_find_backlight_by_node-function.patch
backlight-88pm860x_bl-remove-an-unnecessary-line-continuation.patch
binfmt_elf-fix-corner-case-kfree-of-uninitialized-data-checkpatch-fixes.patch
rtc-avoid-calling-platform_device_put-twice-in-test_init-fix.patch
procfs-add-vmflags-field-in-smaps-output-v4.patch
procfs-add-vmflags-field-in-smaps-output-v4-fix.patch
docs-add-documentation-about-proc-pid-fdinfo-fd-output-fix.patch
scatterlist-dont-bug-when-we-can-trivially-return-a-proper-error-fix.patch

