Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3431736494E
	for <mm-commits@vger.kernel.org>; Sun, 22 Mar 2026 00:37:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774139854; cv=none; b=sBPuK8uaB5F0W8Awojn509pTHfmbmP8XcDYBpsqsqjp1GUhPtRmhNnZnQejzV16lDrozNNaCS1xK2yfmmHIoX9MA+zjA1NLqXLI14CSy8c9wHZ4ytaQzQNjh0EVR40Ffp+IgagjUyRP2kknoxbQwgNHgpFhFqU+2ZwTWJ08lEYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774139854; c=relaxed/simple;
	bh=C4xQT6xT/m5XqY95wfsWNLCa2gA7VcOABkGILk5cxCM=;
	h=Date:To:From:Subject:Message-Id; b=lyJIP3pIMnXO78zn280bSmyhemB15LpnZZyhs6Z5twaYxyggjKtDdzLJKo+ee5rJDqX0T9Jtc6QmRdYT47wMVcUT2EHpHBvat6lQKrU9W3mJjf68rzaN3CakOXKE1Q6FFuSmQAO5llwjN8p8LPUW+WZUJS9pAwN/FgCpI9jbbSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bT3H8YsY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bT3H8YsY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD039C19421;
	Sun, 22 Mar 2026 00:37:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774139853;
	bh=C4xQT6xT/m5XqY95wfsWNLCa2gA7VcOABkGILk5cxCM=;
	h=Date:To:From:Subject:From;
	b=bT3H8YsYe2P9SVZyKWueaiUV+Pv+FyhD0eO4BAD2h4gMWw+tHY0F1V7THMWkxfxbG
	 6g0bkXVdGMQHcj5FgoNuVMyMTRn6PAn68f7QbP6R71k0LyAGoLnWIGdCODfz2bFEGj
	 LLJIkKlFsw1MKWhCnsg0WBfZQORIDSXpoURmPYLU=
Date: Sat, 21 Mar 2026 17:37:33 -0700
To: mm-commits@vger.kernel.org,sln@onemain.com,martink@posteo.de,kuba@kernel.org,hverkuil@kernel.org,carlos.bilbao@kernel.org,arnd@arndb.de,usama.anjum@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mailmap-update-email-address-for-muhammad-usama-anjum.patch removed from -mm tree
Message-Id: <20260322003733.BD039C19421@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mailmap: update email address for Muhammad Usama Anjum
has been removed from the -mm tree.  Its filename was
     mailmap-update-email-address-for-muhammad-usama-anjum.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Muhammad Usama Anjum <usama.anjum@arm.com>
Subject: mailmap: update email address for Muhammad Usama Anjum
Date: Tue, 10 Mar 2026 17:17:39 +0000

Add updated email address.

Link: https://lkml.kernel.org/r/20260310171757.3970390-1-usama.anjum@arm.com
Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Carlos Bilbao <carlos.bilbao@kernel.org>
Cc: Hans Verkuil <hverkuil@kernel.org>
Cc: Jakub Kacinski <kuba@kernel.org>
Cc: Martin Kepplinger <martink@posteo.de>
Cc: Shannon Nelson <sln@onemain.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    1 +
 1 file changed, 1 insertion(+)

--- a/.mailmap~mailmap-update-email-address-for-muhammad-usama-anjum
+++ a/.mailmap
@@ -587,6 +587,7 @@ Morten Welinder <terra@gnome.org>
 Morten Welinder <welinder@anemone.rentec.com>
 Morten Welinder <welinder@darter.rentec.com>
 Morten Welinder <welinder@troll.com>
+Muhammad Usama Anjum <usama.anjum@arm.com> <usama.anjum@collabora.com>
 Mukesh Ojha <quic_mojha@quicinc.com> <mojha@codeaurora.org>
 Muna Sinada <quic_msinada@quicinc.com> <msinada@codeaurora.org>
 Murali Nalajala <quic_mnalajal@quicinc.com> <mnalajal@codeaurora.org>
_

Patches currently in -mm which might be from usama.anjum@arm.com are


