From: akpm@linux-foundation.org
Subject: [merged] classmate-laptop-add-some-keys-present-in-other-devices.patch removed from -mm tree
Date: Wed, 03 Mar 2010 12:04:50 -0800
Message-ID: <201003032004.o23K4oXP028526@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54900 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756480Ab0CCUFN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Mar 2010 15:05:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cascardo@holoscopio.com, don@syst.com.br, len.brown@intel.com, mjg@redhat.com, mm-commits@vger.kernel.org


The patch titled
     classmate-laptop: add some keys present in other devices
has been removed from the -mm tree.  Its filename was
     classmate-laptop-add-some-keys-present-in-other-devices.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: classmate-laptop: add some keys present in other devices
From: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>

Some new devices have extra keys, which we add to our list.  Currently,
they all generate events that allow us to use a simple table/array,
without need for the sparse keymap.

Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Cc: Daniel Oliveira Nascimento <don@syst.com.br>
Cc: Matthew Garrett <mjg@redhat.com>
Cc: Len Brown <len.brown@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/platform/x86/classmate-laptop.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN drivers/platform/x86/classmate-laptop.c~classmate-laptop-added-some-keys-present-in-other-devices drivers/platform/x86/classmate-laptop.c
--- a/drivers/platform/x86/classmate-laptop.c~classmate-laptop-added-some-keys-present-in-other-devices
+++ a/drivers/platform/x86/classmate-laptop.c
@@ -507,6 +507,10 @@ static int cmpc_keys_codes[] = {
 	KEY_BRIGHTNESSDOWN,
 	KEY_BRIGHTNESSUP,
 	KEY_VENDOR,
+	KEY_UNKNOWN,
+	KEY_CAMERA,
+	KEY_BACK,
+	KEY_FORWARD,
 	KEY_MAX
 };
 
_

Patches currently in -mm which might be from cascardo@holoscopio.com are

origin.patch
linux-next.patch
eisa-fix-coding-style-for-eisa-bus-code.patch

