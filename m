From: akpm@linux-foundation.org
Subject: + merge_configsh-whitespace-cleanup.patch added to -mm tree
Date: Mon, 21 Nov 2011 13:30:58 -0800
Message-ID: <201111212130.pALLUwAe014186@wpaz5.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vw0-f74.google.com ([209.85.212.74]:37516 "EHLO
	mail-vw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756916Ab1KUVbB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 21 Nov 2011 16:31:01 -0500
Received: by vbbfr13 with SMTP id fr13so389115vbb.1
        for <mm-commits@vger.kernel.org>; Mon, 21 Nov 2011 13:31:00 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dvhart@linux.intel.com, john.stultz@linaro.org, mmarek@suse.cz


The patch titled
     Subject: merge_config.sh: whitespace cleanup
has been added to the -mm tree.  Its filename is
     merge_configsh-whitespace-cleanup.patch

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
From: Darren Hart <dvhart@linux.intel.com>
Subject: merge_config.sh: whitespace cleanup

Fix whitespace usage in the clean_up routine.

Signed-off-by: Darren Hart <dvhart@linux.intel.com>
Acked-by: John Stultz <john.stultz@linaro.org>
Cc: Michal Marek <mmarek@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/kconfig/merge_config.sh |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN scripts/kconfig/merge_config.sh~merge_configsh-whitespace-cleanup scripts/kconfig/merge_config.sh
--- a/scripts/kconfig/merge_config.sh~merge_configsh-whitespace-cleanup
+++ a/scripts/kconfig/merge_config.sh
@@ -21,8 +21,8 @@
 #  See the GNU General Public License for more details.
 
 clean_up() {
-       rm -f $TMP_FILE
-       exit
+	rm -f $TMP_FILE
+	exit
 }
 trap clean_up HUP INT TERM
 
_
Subject: Subject: merge_config.sh: whitespace cleanup

Patches currently in -mm which might be from dvhart@linux.intel.com are

linux-next.patch
kconfig-add-merge_configsh-script.patch
merge_configsh-use-signal-names-compatible-with-dash-and-bash.patch
merge_configsh-whitespace-cleanup.patch

