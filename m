Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44937C2F2
	for <mm-commits@vger.kernel.org>; Thu,  8 Aug 2024 01:42:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723081332; cv=none; b=MYb6adCZRCL7CLn8J7JuFBu1pzHBnBee5DERNuS48jnsSrl7oB9j1TV6Kz+nWV0JMdapQOyYARVFEJ2c8AD05c3GyURDH8vsl8VYIj3rkYEzH9Jb6ee3nNr0Qan7iji5EZnWcSTrCdI6hMnXLZWFA3ypM5N+/Sm8P4fudQ+aEfc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723081332; c=relaxed/simple;
	bh=KrzxGIfxJDTK8b+ACFe4HYk+eneESyPwZ4e2u9o2Iuc=;
	h=Date:To:From:Subject:Message-Id; b=Wpq1WVOLqdbyy1wDxMR8xwBPGcLHtRZQA1H1Q6jqLfjUa8/30xrXO/Pb/mYYmONJyiroVTW5AnO9AaWXToRssGV6I0HOBuwE4DMu3aeuRcI9fByEOoFpNOhq7EXd3bT4HvcT8ic2I03cXbJa18s4Q6SWB+FhtEFXTWMlvh88lzg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Yb7LRNed; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Yb7LRNed"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 120DFC32781;
	Thu,  8 Aug 2024 01:42:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1723081332;
	bh=KrzxGIfxJDTK8b+ACFe4HYk+eneESyPwZ4e2u9o2Iuc=;
	h=Date:To:From:Subject:From;
	b=Yb7LRNed512nOQ+RmfAc2RIEHpNfCx5aWtD6Jjr0YYE8myNYcsHiDNqAsyt/OEm5p
	 uaLAJ0NqFIJVkq6uTanTA4RL71OBgr4xBKujbSc81dp+r5zR591ODGUAYzJFv3mz6V
	 Zma43uLcceTzqH8bAggzY7fBsvAqvESQCsrEVHiE=
Date: Wed, 07 Aug 2024 18:42:11 -0700
To: mm-commits@vger.kernel.org,manivannan.sadhasivam@linaro.org,jikos@kernel.org,davem@davemloft.net,david@ixit.cz,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mailmap-update-entry-for-david-heidelberg.patch removed from -mm tree
Message-Id: <20240808014212.120DFC32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mailmap: update entry for David Heidelberg
has been removed from the -mm tree.  Its filename was
     mailmap-update-entry-for-david-heidelberg.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Heidelberg <david@ixit.cz>
Subject: mailmap: update entry for David Heidelberg
Date: Sun, 4 Aug 2024 14:45:54 +0900

Link my old gmail address to my active email.

Link: https://lkml.kernel.org/r/20240804054704.859503-1-david@ixit.cz
Signed-off-by: David Heidelberg <david@ixit.cz>
Cc: David S. Miller <davem@davemloft.net>
Cc: Jiri Kosina <jikos@kernel.org>
Cc: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    1 +
 1 file changed, 1 insertion(+)

--- a/.mailmap~mailmap-update-entry-for-david-heidelberg
+++ a/.mailmap
@@ -166,6 +166,7 @@ Daniel Borkmann <daniel@iogearbox.net> <
 Daniel Borkmann <daniel@iogearbox.net> <dxchgb@gmail.com>
 David Brownell <david-b@pacbell.net>
 David Collins <quic_collinsd@quicinc.com> <collinsd@codeaurora.org>
+David Heidelberg <david@ixit.cz> <d.okias@gmail.com>
 David Rheinsberg <david@readahead.eu> <dh.herrmann@gmail.com>
 David Rheinsberg <david@readahead.eu> <dh.herrmann@googlemail.com>
 David Rheinsberg <david@readahead.eu> <david.rheinsberg@gmail.com>
_

Patches currently in -mm which might be from david@ixit.cz are


