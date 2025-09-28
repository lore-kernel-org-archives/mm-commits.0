Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C7D734BA4D
	for <mm-commits@vger.kernel.org>; Sun, 28 Sep 2025 18:52:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759085537; cv=none; b=tyYkHiCtSG3hCfrVnzDfTBKwvtQ4zzzspUcuKhKu559Jg4WHp5vmjRXOjpDcsx8KMxolRpZsZy4N2r4Xfzpxca724VySiJGX86FLLvbax5kbFgD8vcrNW6TsCv3AMe4VsDz8EghlcZxh44Y4KsIgreANffSZSgZhcp6TwzmMJQc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759085537; c=relaxed/simple;
	bh=qiLQ6ZWj70C4+pd6ufvPZHqD31h6MAr5f8/JbNxLvNg=;
	h=Date:To:From:Subject:Message-Id; b=oX9efCWtwGRnBHMav2WWtK3pgS81447qy1UgPQwXVDoA5JoOWCure34u0v2RTVAk4F5N4rahjFtNU4kgf8MwpJjFHkWB6dC1FoniCUlo86DSKzIFmJcX2V2P60CY4wvApl4zMs22jq5QOzm9UV1WtCmOnew4F7rBhpY4swjEC8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=moVLHrYc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="moVLHrYc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17CABC4CEF0;
	Sun, 28 Sep 2025 18:52:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1759085537;
	bh=qiLQ6ZWj70C4+pd6ufvPZHqD31h6MAr5f8/JbNxLvNg=;
	h=Date:To:From:Subject:From;
	b=moVLHrYcXXexK2oA8/UnAdQZFYc6c4Z8vTJuVWm68xbRCLz7rX4yaWCuAkxy6ozhC
	 EtdV3tMDMAR8LjaoOad70Xc6ue+uVu2Jwvqn2vtPygy7MDblHN7D5SsCxv5lXlgx5A
	 QtFzih2lnVbHnYBG1SmSn+nt0f5X/gxzXyoqHVpk=
Date: Sun, 28 Sep 2025 11:52:16 -0700
To: mm-commits@vger.kernel.org,manish1588@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memory_hotplug-fix-typo-esecially-especially.patch removed from -mm tree
Message-Id: <20250928185217.17CABC4CEF0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/memory_hotplug: fix typo 'esecially' -> 'especially'
has been removed from the -mm tree.  Its filename was
     mm-memory_hotplug-fix-typo-esecially-especially.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Manish Kumar <manish1588@gmail.com>
Subject: mm/memory_hotplug: fix typo 'esecially' -> 'especially'
Date: Thu, 18 Sep 2025 23:15:28 +0530

Link: https://lkml.kernel.org/r/20250918174528.90879-1-manish1588@gmail.com
Signed-off-by: Manish Kumar <manish1588@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memory_hotplug.c~mm-memory_hotplug-fix-typo-esecially-especially
+++ a/mm/memory_hotplug.c
@@ -955,7 +955,7 @@ static struct zone *default_kernel_zone_
  *    effectively unused by the kernel, yet they account to "present pages".
  *    Fortunately, these allocations are comparatively small in relevant setups
  *    (e.g., fraction of system memory).
- * b) Some hotplugged memory blocks in virtualized environments, esecially
+ * b) Some hotplugged memory blocks in virtualized environments, especially
  *    hotplugged by virtio-mem, look like they are completely present, however,
  *    only parts of the memory block are actually currently usable.
  *    "present pages" is an upper limit that can get reached at runtime. As
_

Patches currently in -mm which might be from manish1588@gmail.com are


