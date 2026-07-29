Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CA6624DCF9
	for <mm-commits@vger.kernel.org>; Wed, 29 Jul 2026 00:38:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785285491; cv=none; b=MI+c4P7mtBlDrNtv6tvv1CPOGPVLRDyOQ52c0GgSbH8fjanHmft+eaal76SU19ay93M1ILXZooxEQa+3HXF/v7u1GlpxDMd7VShPo3zRwwmnMDeWiFuC++INTS783lO0qnhA70eETB8BERSREpPsRgmbzkVs2m02p6l/gUvPOv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785285491; c=relaxed/simple;
	bh=KvbQzmbl9m6VVGWT8Tn94W7YClXAkNKboHignYPZ3iE=;
	h=Date:To:From:Subject:Message-Id; b=ghT/+ukoBPjpMe53m9w/xisVIPKaSxMF3QvCEmjAb2v0c0qO9vYSw4RI082GfJgMwkkDxBIMfMeeMb1Fl60s6sXtfepBiKI81Vua1sQVdWZfE7D6C6XlPrW8M6ZnlKQpUKIFp665hg5qFGsnQo/8q+9xvjUwCMhz3AsXaihpC1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=R0AkMSDq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="R0AkMSDq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 633F71F000E9;
	Wed, 29 Jul 2026 00:38:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785285490;
	bh=vS6U2dDoadGo3AypyfO2uFlLcIA+3sFZFEEzf9nmg7E=;
	h=Date:To:From:Subject;
	b=R0AkMSDq1VDZxk7pk/hhgOaBTcHiWaMesVYhUFWlJv/Si/Fx8rpt/OA+MJ7TowV89
	 it8useMcMXesGUBDHig1ckiRGl5ZbP1PU+6h1QDu2P5IKWafAy3XTqfn2//K6zh4B5
	 /V9HhYyLaNdcUUnYVSU5kY0+gA+VKyf3sKJUyOs4=
Date: Tue, 28 Jul 2026 17:38:09 -0700
To: mm-commits@vger.kernel.org,npache@redhat.com,david@kernel.org,nico.pache@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] maintainers-update-nico-paches-email-address.patch removed from -mm tree
Message-Id: <20260729003810.633F71F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: MAINTAINERS: update Nico Pache's email address
has been removed from the -mm tree.  Its filename was
     maintainers-update-nico-paches-email-address.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Nico Pache (Red Hat)" <nico.pache@linux.dev>
Subject: MAINTAINERS: update Nico Pache's email address
Date: Tue, 21 Jul 2026 04:18:11 -0600

Switch my entry in MAINTAINERS and .mailmap to my @linux.dev email address

Link: https://lore.kernel.org/20260721101811.115954-1-nico.pache@linux.dev
Signed-off-by: Nico Pache <npache@redhat.com>
Signed-off-by: Nico Pache (Red Hat) <nico.pache@linux.dev>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap    |    1 +
 MAINTAINERS |    2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

--- a/.mailmap~maintainers-update-nico-paches-email-address
+++ a/.mailmap
@@ -649,6 +649,7 @@ Nicholas Piggin <npiggin@gmail.com> <npi
 Nicholas Piggin <npiggin@gmail.com> <nickpiggin@yahoo.com.au>
 Nicholas Piggin <npiggin@gmail.com> <piggin@cyberone.com.au>
 Nicolas Ferre <nicolas.ferre@microchip.com> <nicolas.ferre@atmel.com>
+Nico Pache <nico.pache@linux.dev> <npache@redhat.com>
 Nicolas Pitre <nico@fluxnic.net> <nicolas.pitre@linaro.org>
 Nicolas Pitre <nico@fluxnic.net> <nico@linaro.org>
 Nicolas Saenz Julienne <nsaenz@kernel.org> <nsaenzjulienne@suse.de>
--- a/MAINTAINERS~maintainers-update-nico-paches-email-address
+++ a/MAINTAINERS
@@ -17253,7 +17253,7 @@ M:	Lorenzo Stoakes <ljs@kernel.org>
 R:	Zi Yan <ziy@nvidia.com>
 R:	Baolin Wang <baolin.wang@linux.alibaba.com>
 R:	Liam R. Howlett <liam@infradead.org>
-R:	Nico Pache <npache@redhat.com>
+R:	Nico Pache <nico.pache@linux.dev>
 R:	Ryan Roberts <ryan.roberts@arm.com>
 R:	Dev Jain <dev.jain@arm.com>
 R:	Barry Song <baohua@kernel.org>
_

Patches currently in -mm which might be from nico.pache@linux.dev are


