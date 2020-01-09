From: akpm@linux-foundation.org
Subject: [failures]
 init-fixed-an-error-caused-by-using-__initdata-instead-of-__initconst.patch
 removed from -mm tree
Date: Thu, 09 Jan 2020 11:17:58 -0800
Message-ID: <20200109191758.abJOy3H7t%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:47892 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726139AbgAITR6 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 9 Jan 2020 14:17:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: carlosteniswarrior@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: init/main.c: use __initdata instead of __initconst
has been removed from the -mm tree.  Its filename was
     init-fixed-an-error-caused-by-using-__initdata-instead-of-__initconst.patch

This patch was dropped because it had testing failures

------------------------------------------------------
From: Carlos Guerrero Alvarez <carlosteniswarrior@gmail.com>
Subject: init/main.c: use __initdata instead of __initconst

Link: http://lkml.kernel.org/r/20200106020217.13234-1-carlosteniswarrior@gmail.com
Signed-off-by: Carlos Guerrero Alvarez <carlosteniswarrior@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/init/main.c~init-fixed-an-error-caused-by-using-__initdata-instead-of-__initconst
+++ a/init/main.c
@@ -979,7 +979,7 @@ static initcall_entry_t *initcall_levels
 };
 
 /* Keep these in sync with initcalls in include/linux/init.h */
-static const char *initcall_level_names[] __initdata = {
+static const char *initcall_level_names[] __initconst = {
 	"pure",
 	"core",
 	"postcore",
_

Patches currently in -mm which might be from carlosteniswarrior@gmail.com are
