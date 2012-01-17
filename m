From: akpm@linux-foundation.org
Subject: [merged] merge_configsh-whitespace-cleanup.patch removed from -mm tree
Date: Tue, 17 Jan 2012 13:01:03 -0800
Message-ID: <20120117210104.0848D200057@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fx0-f74.google.com ([209.85.161.74]:63151 "EHLO
	mail-fx0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755118Ab2AQVBF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 17 Jan 2012 16:01:05 -0500
Received: by mail-fx0-f74.google.com with SMTP id p21so54354faa.1
        for <mm-commits@vger.kernel.org>; Tue, 17 Jan 2012 13:01:05 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dvhart@linux.intel.com, john.stultz@linaro.org, mmarek@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: merge_config.sh: whitespace cleanup
has been removed from the -mm tree.  Its filename was
     merge_configsh-whitespace-cleanup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

Patches currently in -mm which might be from dvhart@linux.intel.com are

origin.patch
linux-next.patch

