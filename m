From: akpm@linux-foundation.org
Subject: + classmate-laptop-add-some-keys-present-in-other-devices.patch added to -mm tree
Date: Tue, 02 Mar 2010 13:26:33 -0800
Message-ID: <201003022126.o22LQXKu030481@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44719 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750905Ab0CBV1M (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Mar 2010 16:27:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: cascardo@holoscopio.com, don@syst.com.br, len.brown@intel.com, mjg@redhat.com


The patch titled
     classmate-laptop: add some keys present in other devices
has been added to the -mm tree.  Its filename is
     classmate-laptop-add-some-keys-present-in-other-devices.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
thinkpad-acpi-make-driver-events-work-in-nvram-poll-mode.patch
classmate-laptop-add-some-keys-present-in-other-devices.patch
eisa-fix-coding-style-for-eisa-bus-code.patch

