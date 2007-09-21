From: akpm@linux-foundation.org
Subject: - ata_piix-replace-spaces-with-tabs.patch removed from -mm tree
Date: Fri, 21 Sep 2007 14:08:22 -0700
Message-ID: <200709212108.l8LL8MYR023569@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47361 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762932AbXIUVSx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Sep 2007 17:18:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jason.d.gaston@intel.com, alan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     ata_piix: replace spaces with tabs
has been removed from the -mm tree.  Its filename was
     ata_piix-replace-spaces-with-tabs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ata_piix: replace spaces with tabs
From: Jason Gaston <jason.d.gaston@intel.com>

This patch removes some incorrect formatting spaces and replaces them with
tabs.

Signed-off-by: Jason Gaston <jason.d.gaston@intel.com>
Reviewed-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/ata_piix.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff -puN drivers/ata/ata_piix.c~ata_piix-replace-spaces-with-tabs drivers/ata/ata_piix.c
--- a/drivers/ata/ata_piix.c~ata_piix-replace-spaces-with-tabs
+++ a/drivers/ata/ata_piix.c
@@ -437,15 +437,15 @@ static const struct piix_map_db ich8_map
 };
 
 static const struct piix_map_db tolapai_map_db = {
-        .mask = 0x3,
-        .port_enable = 0x3,
-        .map = {
-                /* PM   PS   SM   SS       MAP */
-                {  P0,  NA,  P1,  NA }, /* 00b */
-                {  RV,  RV,  RV,  RV }, /* 01b */
-                {  RV,  RV,  RV,  RV }, /* 10b */
-                {  RV,  RV,  RV,  RV },
-        },
+	.mask = 0x3,
+	.port_enable = 0x3,
+	.map = {
+		/* PM   PS   SM   SS       MAP */
+		{  P0,  NA,  P1,  NA }, /* 00b */
+		{  RV,  RV,  RV,  RV }, /* 01b */
+		{  RV,  RV,  RV,  RV }, /* 10b */
+		{  RV,  RV,  RV,  RV },
+	},
 };
 
 static const struct piix_map_db *piix_map_db_table[] = {
_

Patches currently in -mm which might be from jason.d.gaston@intel.com are

git-libata-all.patch
