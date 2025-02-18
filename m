Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C00601B3922
	for <mm-commits@vger.kernel.org>; Tue, 18 Feb 2025 06:40:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739860849; cv=none; b=BvPOGwkm1pq2WvY4/ppNcsOns6EBaQKnb79Q0lzOkwFqAGy19yw+wI9MPKjeEpxHi5M+QcYVlQsPfa94IMSdF0ZPhWrzMIBsDqNXJYlOFNQfYuRKK5CU74OdRSM9cs4gKmVznjRuar0uVgcQgFqrAkYBHWdupVpc7BXQ/m3HOBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739860849; c=relaxed/simple;
	bh=8actWqCLi2W/gjbjmihyw6ubEe5Q9N6hy/IJHnZDFvk=;
	h=Date:To:From:Subject:Message-Id; b=CyynuupYtH5bDcxGQAnLpFiuLNfNA7yTLAsuFUSl8Pa+xqAOjwMr/j2WfXUKcnvTm9xmqkTXloT+2VW4aSTAXvamqklj9WufWXIDUYtqx3yIndIdp9byPZ09O0yhyYGOXUk/HmBIhY8cyCi0S3VSDycK1F0D72K8qK0NYfIVt9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zGtcQsFC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zGtcQsFC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E179C4CEE2;
	Tue, 18 Feb 2025 06:40:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1739860849;
	bh=8actWqCLi2W/gjbjmihyw6ubEe5Q9N6hy/IJHnZDFvk=;
	h=Date:To:From:Subject:From;
	b=zGtcQsFC7LKXUEoN/S08ylc9pcaijiWLKoRhsROQ/75ITEDgm/ekZb08ISGvuY4HR
	 jn4aH364A3kVcgj5J/cg6lGOqlZBKujYJ1IePb+DMlp80+fP57Olh0933kkoTDMTBS
	 H4B3G89tgH5ekaqX3bzJ+eTHeb/fk5ue/+nV7KoU=
Date: Mon, 17 Feb 2025 22:40:48 -0800
To: mm-commits@vger.kernel.org,feng.tang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mailmap-add-entry-for-feng-tang.patch removed from -mm tree
Message-Id: <20250218064049.8E179C4CEE2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mailmap: add entry for Feng Tang
has been removed from the -mm tree.  Its filename was
     mailmap-add-entry-for-feng-tang.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Feng Tang <feng.tang@linux.alibaba.com>
Subject: mailmap: add entry for Feng Tang
Date: Wed, 5 Feb 2025 14:04:57 +0800

Map my old business email to personal email.

Link: https://lkml.kernel.org/r/20250205060457.53667-1-feng.tang@linux.alibaba.com
Signed-off-by: Feng Tang <feng.tang@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    1 +
 1 file changed, 1 insertion(+)

--- a/.mailmap~mailmap-add-entry-for-feng-tang
+++ a/.mailmap
@@ -226,6 +226,7 @@ Fangrui Song <i@maskray.me> <maskray@goo
 Felipe W Damasio <felipewd@terra.com.br>
 Felix Kuhling <fxkuehl@gmx.de>
 Felix Moeller <felix@derklecks.de>
+Feng Tang <feng.79.tang@gmail.com> <feng.tang@intel.com>
 Fenglin Wu <quic_fenglinw@quicinc.com> <fenglinw@codeaurora.org>
 Filipe Lautert <filipe@icewall.org>
 Finn Thain <fthain@linux-m68k.org> <fthain@telegraphics.com.au>
_

Patches currently in -mm which might be from feng.tang@linux.alibaba.com are


