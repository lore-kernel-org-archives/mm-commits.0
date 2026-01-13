Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46AA625487C
	for <mm-commits@vger.kernel.org>; Tue, 13 Jan 2026 04:37:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768279047; cv=none; b=tUWISxvdHaTrj3c16mRX+PmNeviA5FEqnGEZwsY0CgyIC3zo8aDET0BqfLxXy6obR+AY23YEnR4PzqU02S6Ih85TsxTemDbkLaHGBKXF0A603Engq2mR8n2qyFSHjuVuV3JQLgnDQGGqTfZnbnOCllb7EnBBwjZ1V6fxQqAqyDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768279047; c=relaxed/simple;
	bh=E0aPR7EGPiyXrZY8rU/USwZMc0B7yYvEGWzSSbCkO/g=;
	h=Date:To:From:Subject:Message-Id; b=RPFHSok8g2IOqghwszJhiQ7m+iv8zMyj1PWg68P+FDxwCXh4D0ZfnysM1XKquO+gEzcm7zPJLF6jg0rhIkHAVb2gHssRQLMoUume/tTQLItot+5IAxwlgLVb+gp+gt7U3bmQUFQWH62H5KednSrHL/RArgu1XqrxOi4OGX7Ld8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=AKMbVo7K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="AKMbVo7K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0EC6C116C6;
	Tue, 13 Jan 2026 04:37:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768279046;
	bh=E0aPR7EGPiyXrZY8rU/USwZMc0B7yYvEGWzSSbCkO/g=;
	h=Date:To:From:Subject:From;
	b=AKMbVo7KsyoFFuWhT7CJofZahujhpygLA9kK+KH6xcmndioJj9QFlcLDmaIdrVyNF
	 +vNRlNOhnNvAlo7v/D8niMul216veECu637RA4fXBd1AlmdybEfVNk2bbGWaBE/LdC
	 juDtTyInjD3icFS37wfG65LAqx+lDFLcIk6e6unY=
Date: Mon, 12 Jan 2026 20:37:25 -0800
To: mm-commits@vger.kernel.org,corbet@lwn.net,diego.viola@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] credits-add-whitespace-before-opening-parentheses.patch removed from -mm tree
Message-Id: <20260113043726.C0EC6C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: CREDITS: add whitespace before opening parentheses
has been removed from the -mm tree.  Its filename was
     credits-add-whitespace-before-opening-parentheses.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Diego Viola <diego.viola@gmail.com>
Subject: CREDITS: add whitespace before opening parentheses
Date: Sat, 10 Jan 2026 21:23:52 -0300

In order to maintain consistent formatting across the file.

Link: https://lkml.kernel.org/r/20260111002353.4592-1-diego.viola@gmail.com
Signed-off-by: Diego Viola <diego.viola@gmail.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 CREDITS |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/CREDITS~credits-add-whitespace-before-opening-parentheses
+++ a/CREDITS
@@ -695,7 +695,7 @@ S: USA
 N: Chih-Jen Chang
 E: chihjenc@scf.usc.edu
 E: chihjen@iis.sinica.edu.tw
-D: IGMP(Internet Group Management Protocol) version 2
+D: IGMP (Internet Group Management Protocol) version 2
 S: 3F, 65 Tajen street
 S: Tamsui town, Taipei county,
 S: Taiwan 251
@@ -1997,7 +1997,7 @@ E: bkaindl@netway.at
 E: edv@bartelt.via.at
 D: Author of a menu based configuration tool, kmenu, which
 D: is the predecessor of 'make menuconfig' and 'make xconfig'.
-D: digiboard driver update(modularisation work and 2.1.x upd)
+D: digiboard driver update (modularisation work and 2.1.x upd)
 S: Tallak 95
 S: 8103 Rein
 S: Austria
@@ -3609,7 +3609,7 @@ S: Finland
 N: Deepak Saxena
 E: dsaxena@plexity.net
 D: I2O kernel layer (config, block, core, pci, net). I2O disk support for LILO
-D: XScale(IOP, IXP) porting and other random ARM bits
+D: XScale (IOP, IXP) porting and other random ARM bits
 S: Portland, OR
 
 N: Eric Schenk
@@ -3986,7 +3986,7 @@ S: D-50968 Köln
 
 N: Tsu-Sheng Tsao
 E: tsusheng@scf.usc.edu
-D: IGMP(Internet Group Management Protocol) version 2
+D: IGMP (Internet Group Management Protocol) version 2
 S: 2F 14 ALY 31 LN 166 SEC 1 SHIH-PEI RD
 S: Taipei
 S: Taiwan 112
_

Patches currently in -mm which might be from diego.viola@gmail.com are


