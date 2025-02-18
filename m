Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F5E41B218A
	for <mm-commits@vger.kernel.org>; Tue, 18 Feb 2025 06:40:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739860857; cv=none; b=m/ZQZ3ASc3IQmMnS4n/ACC3yhfNgFCcCMKXoQstFTzOOeLBiM/IUhgUWJpblaefS1CPMKQ7O6wbEu3SHxO13WpzGkKK1nxLzp7yaTz4tHXgm7AqJ9Za5Aw+uEace1snVqeNlSvyfo88ig4Ql/qeAK8e8zBr6KJX8BqXIZClbX2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739860857; c=relaxed/simple;
	bh=DFvlofeU/lwVaIQrEvlIlWGIBBIF8Pn3+t2Cu2vl7WU=;
	h=Date:To:From:Subject:Message-Id; b=ndDxoezqiLsGzHxvOCEXmpNKduti+sR5FujNORgY0B3ridfTWpCVWAmysHOmcjop5trZ8DDEIocwtZjnmnEhz4SNDCIB1zIfV/4bXx69H4SywuvR96MRRvPX1W2OpwhCYumDQtFBuydLMbIa+AIvvXLuIaudKEANfKokBsaVw8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Ub6C/CvR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Ub6C/CvR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A567C4CEE8;
	Tue, 18 Feb 2025 06:40:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1739860857;
	bh=DFvlofeU/lwVaIQrEvlIlWGIBBIF8Pn3+t2Cu2vl7WU=;
	h=Date:To:From:Subject:From;
	b=Ub6C/CvRbKYgOoUwJog4+VIoYzz9HAuCg2OHuLvhMTJ/Tqa8bszQcjCQTsAurhdLR
	 HiWcr9YMtTZpsn37v59eMTqYQ+7F+8zFLEBIS1bozlD6FgCBDx1Bb4qZReYCBbVbla
	 ZIOIBe4QvuGcvvLoq4m9GzQ1Cv6Hf9lsfwdYskRc=
Date: Mon, 17 Feb 2025 22:40:56 -0800
To: mm-commits@vger.kernel.org,ndesaulniers@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mailmap-update-my-entry.patch removed from -mm tree
Message-Id: <20250218064057.0A567C4CEE8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mailmap: update Nick's entry
has been removed from the -mm tree.  Its filename was
     mailmap-update-my-entry.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Nick Desaulniers <ndesaulniers@google.com>
Subject: mailmap: update Nick's entry
Date: Tue, 11 Feb 2025 13:21:17 -0800

Link: https://lkml.kernel.org/r/20250211212117.3195265-1-ndesaulniers@google.com
Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    1 +
 1 file changed, 1 insertion(+)

--- a/.mailmap~mailmap-update-my-entry
+++ a/.mailmap
@@ -534,6 +534,7 @@ Nicholas Piggin <npiggin@gmail.com> <npi
 Nicholas Piggin <npiggin@gmail.com> <npiggin@suse.de>
 Nicholas Piggin <npiggin@gmail.com> <nickpiggin@yahoo.com.au>
 Nicholas Piggin <npiggin@gmail.com> <piggin@cyberone.com.au>
+Nick Desaulniers <nick.desaulniers+lkml@gmail.com> <ndesaulniers@google.com>
 Nicolas Ferre <nicolas.ferre@microchip.com> <nicolas.ferre@atmel.com>
 Nicolas Pitre <nico@fluxnic.net> <nicolas.pitre@linaro.org>
 Nicolas Pitre <nico@fluxnic.net> <nico@linaro.org>
_

Patches currently in -mm which might be from ndesaulniers@google.com are


