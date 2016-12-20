From: Andrew Morton <akpm@linux-foundation.org>
Subject: incoming
Date: Mon, 19 Dec 2016 16:22:21 -0800
Message-ID: <20161219162221.9a7501eae18ee6bf84a135d8@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50370 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751758AbcLTAVW (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 19 Dec 2016 19:21:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: mm-commits@vger.kernel.org


- a series to make IMA play better across kexec

- a handful of random fixes

15 patches, based on e93b1cc8a8965da137ffea0b88e5f62fa1d2a9e6:

Subject: powerpc: ima: get the kexec buffer passed by the previous kernel
Subject: ima: on soft reboot, restore the measurement list
Subject: ima: permit duplicate measurement list entries
Subject: ima: maintain memory size needed for serializing the measurement list
Subject: powerpc: ima: send the kexec buffer to the next kernel
Subject: ima: on soft reboot, save the measurement list
Subject: ima: store the builtin/custom template definitions in a list
Subject: ima: support restoring multiple template formats
Subject: ima: define a canonical binary_runtime_measurements list format
Subject: ima: platform-independent hash value
Subject: mm: fadvise: avoid expensive remote LRU cache draining after FADV_DONTNEED
Subject: arm64: setup: introduce kaslr_offset()
Subject: kcov: make kcov work properly with KASLR enabled
Subject: ratelimit: fix WARN_ON_RATELIMIT return value
Subject: printk: fix typo in CONSOLE_LOGLEVEL_DEFAULT help text



