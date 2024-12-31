Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F11B1EEE6
	for <mm-commits@vger.kernel.org>; Tue, 31 Dec 2024 02:00:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735610422; cv=none; b=FJ0aK4RNSa0jg009JB8DlCzIrerPfuFt9UBmb3tVl3NfBr8BpwYwOxHOX6U5Y/z5M6nfMmqrgWpNXvghofppc1Bz1gMVfrZLS2KIN8CDnOneBJSCqnMno12WOxC9OyeCEOY/ivtP628i55VmtXI+Vm9rRMm9WGr4j9uSkrNHnZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735610422; c=relaxed/simple;
	bh=i5GDixO1Fsyez6p9guqZlRqbaNSDRLM7TqMhAB7rFE4=;
	h=Date:To:From:Subject:Message-Id; b=hJ7yIdEC2u8q5O4gC7sKHv0dLIEMKKuqwUwAl1rtxiv7M4EJETb2ul6T9ZO/P7KzYp/WeWN5+JEPCBlv4C3wnGA1Tqmil/agXrlpTWXp6VbSZhmtMwT8zSglTjfEFTKdo6vBTfTy4w7FG011G1hLL6jCGqe5/aIeoWAd9oXUvxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yqS9iyXr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yqS9iyXr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04A98C4CED0;
	Tue, 31 Dec 2024 02:00:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1735610422;
	bh=i5GDixO1Fsyez6p9guqZlRqbaNSDRLM7TqMhAB7rFE4=;
	h=Date:To:From:Subject:From;
	b=yqS9iyXrLwfLb5yX4WsCAC9vTv7x5Pyaum7oySb0R0FER6PoStgrW/hOqMXAqP08h
	 2dKyFWLc6jnlXsRqV//EGCbHfTd7SrTnwOdSoRA8P5wt0JoIUZ6uce5PPe+xmEQebT
	 HJFixINE0AfUbMKtVnt66HJ4rsLVTFAWd45lyus0=
Date: Mon, 30 Dec 2024 18:00:21 -0800
To: mm-commits@vger.kernel.org,chester.a.unal@arinc9.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] maintainers-change-arınc-_nals-name-and-email-address.patch removed from -mm tree
Message-Id: <20241231020022.04A98C4CED0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: MAINTAINERS: change Arınç _NAL's name and email address
has been removed from the -mm tree.  Its filename was
     maintainers-change-arınc-_nals-name-and-email-address.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Chester A. Unal" <chester.a.unal@arinc9.com>
Subject: MAINTAINERS: change Arınç _NAL's name and email address
Date: Wed, 25 Dec 2024 15:50:41 +0300

My legal name now includes Chester. Change the name and the email address
sections to reflect that.

Link: https://lkml.kernel.org/r/20241225-for-unknown-upstream-v1-1-3e35e4d5e161@arinc9.com
Signed-off-by: Chester A. Unal <chester.a.unal@arinc9.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/MAINTAINERS~maintainers-change-arınc-_nals-name-and-email-address
+++ a/MAINTAINERS
@@ -14756,7 +14756,7 @@ F:	drivers/memory/mtk-smi.c
 F:	include/soc/mediatek/smi.h
 
 MEDIATEK SWITCH DRIVER
-M:	Arınç ÜNAL <arinc.unal@arinc9.com>
+M:	Chester A. Unal <chester.a.unal@arinc9.com>
 M:	Daniel Golle <daniel@makrotopia.org>
 M:	DENG Qingfang <dqfext@gmail.com>
 M:	Sean Wang <sean.wang@mediatek.com>
@@ -18460,7 +18460,7 @@ F:	Documentation/devicetree/bindings/pin
 F:	drivers/pinctrl/mediatek/
 
 PIN CONTROLLER - MEDIATEK MIPS
-M:	Arınç ÜNAL <arinc.unal@arinc9.com>
+M:	Chester A. Unal <chester.a.unal@arinc9.com>
 M:	Sergio Paracuellos <sergio.paracuellos@gmail.com>
 L:	linux-mediatek@lists.infradead.org (moderated for non-subscribers)
 L:	linux-mips@vger.kernel.org
@@ -19504,7 +19504,7 @@ S:	Maintained
 F:	arch/mips/ralink
 
 RALINK MT7621 MIPS ARCHITECTURE
-M:	Arınç ÜNAL <arinc.unal@arinc9.com>
+M:	Chester A. Unal <chester.a.unal@arinc9.com>
 M:	Sergio Paracuellos <sergio.paracuellos@gmail.com>
 L:	linux-mips@vger.kernel.org
 S:	Maintained
_

Patches currently in -mm which might be from chester.a.unal@arinc9.com are


