From: akpm@linux-foundation.org
Subject: - udf-fix-function-name-from-udf_crc16-to-udf_crc.patch removed from -mm tree
Date: Mon, 16 Jul 2007 13:58:45 -0700
Message-ID: <200707162058.l6GKwjbt002364@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44721 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754992AbXGPVNF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jul 2007 17:13:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gorcunov@gmail.com, jack@ucw.cz, mm-commits@vger.kernel.org


The patch titled
     UDF: fix function name from udf_crc16 to udf_crc
has been removed from the -mm tree.  Its filename was
     udf-fix-function-name-from-udf_crc16-to-udf_crc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: UDF: fix function name from udf_crc16 to udf_crc
From: Cyrill Gorcunov <gorcunov@gmail.com>

We have to change udf_crc16() name to udf_crc() to be able to play with CRC
test.

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Jan Kara <jack@ucw.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/udf/crc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/udf/crc.c~udf-fix-function-name-from-udf_crc16-to-udf_crc fs/udf/crc.c
--- a/fs/udf/crc.c~udf-fix-function-name-from-udf_crc16-to-udf_crc
+++ a/fs/udf/crc.c
@@ -106,8 +106,8 @@ int main(void)
 {
 	unsigned short x;
 
-	x = udf_crc16(bytes, sizeof bytes);
-	printf("udf_crc16: calculated = %4.4x, correct = %4.4x\n", x, 0x3299U);
+	x = udf_crc(bytes, sizeof bytes);
+	printf("udf_crc: calculated = %4.4x, correct = %4.4x\n", x, 0x3299U);
 
 	return 0;
 }
_

Patches currently in -mm which might be from gorcunov@gmail.com are

origin.patch
sky-cpu-and-nexus-code-style-improvement.patch
sky-cpu-and-nexus-include-ioh.patch
sky-cpu-and-nexus-check-for-platform_get_resource-ret.patch
sky-cpu-and-nexus-check-for-create_proc_entry-ret-code.patch
sky-cpu-use-c99-style-for-struct-init.patch
sky-cpu-and-nexus-get-rid-of-useless-null-init.patch
sky-cpu-and-nexus-use-seq_file-single_open-on-proc-interface.patch
udf-coding-style-conversion-lindent.patch
