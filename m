From: akpm@linux-foundation.org
Subject: - input-add-lenovo-3000-n100-to-nomux-blacklist.patch removed from -mm tree
Date: Fri, 28 Mar 2008 15:00:43 -0700
Message-ID: <200803282200.m2SM0iMA012811@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44213 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751553AbYC1WAw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 28 Mar 2008 18:00:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jkosina@suse.cz, cddesjardins@gmail.com, dtor@mail.ru, mm-commits@vger.kernel.org


The patch titled
     input: add Lenovo 3000 N100 to nomux blacklist
has been removed from the -mm tree.  Its filename was
     input-add-lenovo-3000-n100-to-nomux-blacklist.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: input: add Lenovo 3000 N100 to nomux blacklist
From: Jiri Kosina <jkosina@suse.cz>

Lenovo 3000 N100 needs entry in nomux blacklist.

Reported-by: Christopher Desjardins <cddesjardins@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Cc: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/serio/i8042-x86ia64io.h |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN drivers/input/serio/i8042-x86ia64io.h~input-add-lenovo-3000-n100-to-nomux-blacklist drivers/input/serio/i8042-x86ia64io.h
--- a/drivers/input/serio/i8042-x86ia64io.h~input-add-lenovo-3000-n100-to-nomux-blacklist
+++ a/drivers/input/serio/i8042-x86ia64io.h
@@ -284,6 +284,13 @@ static struct dmi_system_id __initdata i
 			DMI_MATCH(DMI_PRODUCT_VERSION, "3000 N100"),
 		},
 	},
+	{
+		.ident = "Lenovo 3000 n100",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
+			DMI_MATCH(DMI_PRODUCT_VERSION, "3000 N100"),
+		},
+	},
 	{ }
 };
 
_

Patches currently in -mm which might be from jkosina@suse.cz are

git-hid.patch
elantech-touchpad-driver.patch
input-add-lenovo-3000-n100-to-nomux-blacklist.patch
input-touchscreen-driver-add-support-ad7877-touchscreen-driver.patch
xpad-match-xbox-360-devices-with-interface-info.patch
aiptekc-add-support-for-genius-g-pen-560-tablet.patch
ipwireless-remove-dead-code.patch
signals-re-assign-cld_continued-notification-from-the-sender-to-reciever.patch
kill_pid_info-dont-take-now-unneeded-tasklist_lock.patch
handle_stop_signal-unify-partial-full-stop-handling.patch
handle_stop_signal-use-the-cached-p-signal-value.patch
get_signal_to_deliver-use-the-cached-signal-sighand-values.patch
add-macros-similar-to-min-max-min_t-max_t.patch
input-ff-memlessc-use-clamp_val-macro.patch

